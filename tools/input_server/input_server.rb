require 'serverengine'
require 'xbee-ruby'
require 'active_record'
require 'yaml'

root_path = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift("#{root_path}/app")
$LOAD_PATH.unshift("#{root_path}/lib")

require 'models/family'
require 'models/refugee'
require 'models/leader'
require 'refugee_manager/bar_code'

module InputServer
  FAMILY_DATA_PATTERN = /\A[0-9]{8},[1-9][0-9]?\z/

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
            when 'ACK'
              logger.info("<< [ACK] from: #{format_address(response)}")
              respond_to_sender("OK\r\n", response)
            when FAMILY_DATA_PATTERN
              logger.info("<< [Family Data] from: " \
                           "#{format_address(response)}; " \
                           "data: #{data_str.inspect}")
              process_family_data(data_str, response)
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

  def process_family_data(data_str, response)
    bar_code_s, num_of_members_s = data_str.split(',')
    bar_code = RefugeeManager::BarCode.new(bar_code_s)

    unless bar_code.valid?
      raise ArgumentError, "Invalid bar code: #{bar_code_s}"
    end

    bar_code_refuge_id = bar_code.refuge_id
    this_refuge_id = config['refuge_id']
    unless bar_code_refuge_id == this_refuge_id
      raise ArgumentError,
        "Different refuge id: #{bar_code_refuge_id} =/= #{this_refuge_id}"
    end

    # 代表者番号
    leader_id = bar_code.refugee_id
    # 代表者番号
    num_of_members = num_of_members_s.to_i

    leader = Leader.find_by(refugee_id: leader_id)
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
  'refuge_id' => 19,
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
