require 'serverengine'
require 'serialport'
require 'yaml'

# 表示端末との通信を行うサーバー
module DisplayServer
  def run
    logger.level = :info
    logger.info('Starting display server...')

    begin
      @sp = SerialPort.new(config['serial_port'], 9600, 8, 1, 0)
    rescue => sp_open_error
      logger.fatal("SerialPort open error: #{sp_open_error}")
      abort
    end

    begin
      @shelter = Shelter.find(1)
    rescue => get_shelter_error
      logger.fatal("Cannot get the shelter info: #{get_shelter_error}")
      logger.info('Please run "bin/rake db:migrate && bin/rake db:seed_fu"')

      abort
    end

    @server_thread = new_server_thread
    @server_thread.join

    begin
      @sp.close
    rescue => sp_close_error
      logger.fatal("SerialPort close error: #{sp_close_error}")
      abort
    end
  end

  def stop
    @server_thread.kill
  end

  private

  # 新しいサーバースレッドを作成する
  def new_server_thread
    Thread.new do
      shelter_id ="%03d" % @shelter.num
      loop do
        line = @sp.gets.chomp
        logger.debug("<< #{line}")
        case line
        when /@(\d\d\d)DNU/
          if $1 == shelter_id
            refugees_num = Family.sum(:num_of_members)
            @sp.puts "@#{shelter_id}UNU #{refugees_num}\r"
          end
        when /@(\d\d\d)DNP/
          if $1 == shelter_id
            refugees_num = Refugee.where(presence: true).count
            @sp.puts "@#{shelter_id}UNP #{refugees_num}\r"
          end
        end
      end
    end
  end
end

config_path = File.expand_path('config.yml', File.dirname(__FILE__))
default_config = {
  'serial_port' => '/dev/ttyACM0'
}
config = default_config.merge(YAML.load_file(config_path))
se = ServerEngine.create(nil, DisplayServer, config)
se.run
