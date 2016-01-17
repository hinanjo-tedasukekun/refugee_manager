require 'serverengine'
require 'xbee-ruby'
require 'active_record'
require 'active_support/core_ext/object/with_options'
require 'yaml'

root_path = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift("#{root_path}/app")
$LOAD_PATH.unshift("#{root_path}/lib")

require 'models/family'
require 'models/refugee'
require 'models/leader'
require 'models/check_digit_validator'
require 'models/barcode'

module InputServer
  # 世帯情報のパターン
  FAMILY_DATA_PATTERN = /\A# ([0-9]{8}) ([0-9]{1,2})\z/
  # 在室状況のパターン
  PRESENCE_PATTERN = /\AP ([0-9]{8}) ([01])\z/

  # 世帯情報のメッセージを表す構造体
  FamilyDataMessage = Struct.new(:leader_num, :num_of_members, :response)
  # 在室状況のメッセージを表す構造体
  PresenceMessage = Struct.new(:refugee_num, :presence, :response)

  def run
    logger.level = config['log_level']
    logger.info('Starting input server...')

    begin
      @xbee = open_xbee
    rescue => xbee_open_error
      logger.fatal("XBee open error: #{xbee_open_error}")
      abort
    end

    begin
      establish_db_connection
    rescue => db_connection_error
      logger.fatal("Database connection error: #{db_connection_error}")
      abort
    end

    @server_thread = new_server_thread
    @server_thread.join

    begin
      close_xbee(@xbee)
    rescue => xbee_close_error
      logger.fatal("XBee close error: #{xbee_close_error}")
      abort
    end
  end

  def stop
    @server_thread.kill
  end

  private

  # XBee デバイスファイルを開く
  def open_xbee
    xbee_config = config['xbee']
    xbee_port = xbee_config['port']
    xbee_rate = xbee_config['rate']

    xbee = XBeeRuby::XBee.new(port: xbee_port, rate: xbee_rate)
    xbee.open
    logger.info("Opened XBee device: #{xbee_port}")

    xbee
  end

  # XBee デバイスファイルを閉じる
  def close_xbee(xbee)
    xbee.close
    logger.info("Closed XBee device: #{config['xbee']['port']}")

    true
  end

  # データベースへの接続を確立する
  def establish_db_connection
    rails_env = config['rails_env']

    Dir.chdir(config[:root_path])
    db_config = YAML.load_file('config/database.yml')[rails_env]
    ActiveRecord::Base.establish_connection(db_config)

    logger.info(
      "Established database connection (environment: #{rails_env})"
    )

    true
  end

  # 新しいサーバースレッドを作成する
  def new_server_thread
    Thread.new do
      loop do
        begin
          logger.debug('Waiting response')
          response = @xbee.read_response
          case response
          when XBeeRuby::RxResponse
            data_str = response.data.pack('c*').chomp
            case data_str
            when 'C'
              logger.info("<< [Connection] from: #{format_address(response)}")
              respond_to_sender('A', response)
            when FAMILY_DATA_PATTERN
              m = Regexp.last_match
              message = FamilyDataMessage.new(m[1], m[2], response)
              logger.info("<< [Family Data] from: " \
                           "#{format_address(response)}; " \
                           "data: #{data_str.inspect}")
              process_family_data(message)
            when PRESENCE_PATTERN
              m = Regexp.last_match
              message = PresenceMessage.new(m[1], m[2], response)
              logger.info("<< [Presence] from: " \
                           "#{format_address(response)}; " \
                           "data: #{data_str.inspect}")
              process_presence(message)
            else
              log_incoming(response)
            end
          else
            log_incoming(response)
          end
        rescue => e
          logger.error(e.message)
        end
      end
    end
  end

  # 世帯情報のメッセージを処理する
  def process_family_data(message)
    leader_num = message.leader_num
    barcode = Barcode.new(code: leader_num)

    unless barcode.valid?
      raise ArgumentError, "Invalid barcode: #{leader_num}"
    end

    barcode_shelter_id = barcode.shelter_id
    this_shelter_id = config['shelter_id']
    unless barcode_shelter_id == this_shelter_id
      raise ArgumentError,
        "Different shelter id: #{barcode_shelter_id} =/= #{this_shelter_id}"
    end

    # 代表者番号
    leader_id = barcode.refugee_id
    # 代表者番号
    num_of_members = message.num_of_members.to_i

    leader = Leader.find_by(refugee_id: leader_id)
    response = message.response
    if leader
      # 代表者が登録されていれば情報を更新する
      update_family_data(leader, num_of_members)
      respond_to_sender('U', response)
    else
      # 代表者が登録されていなければ情報を登録する
      insert_family_data(leader_id, num_of_members)
      respond_to_sender('R', response)
    end
  rescue => e
    logger.error("Couldn't register data: #{e}")
    respond_to_sender('E', response)
  end

  # 世帯のデータを登録する
  def insert_family_data(leader_id, num_of_members)
    family = nil
    ActiveRecord::Base.transaction do
      family = Family.create!(num_of_members: num_of_members)
      refugee = Refugee.create!(id: leader_id, family: family)
      Leader.create!(family: family, refugee: refugee)
    end

    logger.info("Registered: family_id = #{family.id}, " \
                "leader_id = #{leader_id}, " \
                "num_of_members = #{num_of_members}")
    true
  end

  # 世帯のデータを更新する
  def update_family_data(leader, num_of_members)
    family = nil
    ActiveRecord::Base.transaction do
      family = leader.family
      family.num_of_members = num_of_members
      family.save!
    end

    logger.info("Updated: family_id = #{family.id}, " \
                "leader_id = #{leader.refugee.id}, " \
                "num_of_members = #{num_of_members} ")
    true
  end

  # 在室状況のメッセージを処理する
  def process_presence(message)
    refugee_num = message.refugee_num
    barcode = Barcode.new(code: refugee_num)

    unless barcode.valid?
      raise ArgumentError, "Invalid barcode: #{refugee_num}"
    end

    barcode_shelter_id = barcode.shelter_id
    this_shelter_id = config['shelter_id']
    unless barcode_shelter_id == this_shelter_id
      raise ArgumentError,
        "Different shelter id: #{barcode_shelter_id} =/= #{this_shelter_id}"
    end

    refugee_id = barcode.refugee_id
    refugee = Refugee.find_by(id: refugee_id)
    unless refugee
      raise ArgumentError, "Refugee not found: #{refugee_id}"
    end

    # 在室状況を更新する
    presence = (message.presence == '1')
    response = message.response
    update_presence(refugee, presence)
    respond_to_sender('U', response)
  rescue => e
    logger.error("Couldn't update data: #{e}")
    respond_to_sender('E', response)
  end

  # 在室状況を更新する
  def update_presence(refugee, presence)
    ActiveRecord::Base.transaction do
      refugee.presence = presence
      refugee.save!
    end

    logger.info("Updated: refugee_id = #{refugee.id}, " \
                "presence = #{presence}")
    true
  end

  # 送信してきた端末に返信する
  def respond_to_sender(data, response)
    begin
      request = XBeeRuby::TxRequest.new(
        response.address64,
        data.bytes,
        address16: response.address16
      )

      @xbee.write_request(request)
      logger.debug(">> #{data.inspect} to " \
                   "#{format_address(response)}")
    rescue => e
      logger.error("Response error: #{e}")
    end
  end

  # 送られてきたデータをログに残す
  def log_incoming(response)
    if response.respond_to?(:data)
      logger.debug("<< from: #{format_address(response)}; " \
                  "data: #{data_str.inspect}")
    else
      logger.debug("<< from: #{format_address(response)}; " \
                  "response: #{response}")
    end
  end

  # アドレスを文字列に整形する
  def format_address(response)
    if response.respond_to?(:address64)
      "0x#{response.address64} (0x#{response.address16})"
    else
      "0x#{response.address16}"
    end
  end
end

config_path = File.expand_path('config.yml', File.dirname(__FILE__))
default_config = {
  root_path: root_path,
  log: '-',
  'shelter_id' => 19,
  'xbee' => {
    'port' => '/dev/ttyUSB0',
    'rate' => 9600
  },
  'rails_env' => 'development',
  'log_level' => 'info'
}
config = default_config.merge(YAML.load_file(config_path))
se = ServerEngine.create(nil, InputServer, config)
se.run
