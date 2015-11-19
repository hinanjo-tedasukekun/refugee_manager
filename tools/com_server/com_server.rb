require 'serverengine'
require 'serialport'
require 'active_record'
require 'yaml'

root_path = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift("#{root_path}/app")
$LOAD_PATH.unshift("#{root_path}/lib")

require 'models/family'
require 'models/refugee'
require 'models/leader'
require 'refugee_manager/bar_code'


module ComServer

  def run
    logger.level = :info
    logger.info('Starting Kuno server...')

    begin
      @sp = SerialPort.new(config['serial_port'], 9600, 8, 1, 0)
    rescue => sp_open_error
      logger.fatal("SerialPort open error: #{sp_open_error}")
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
      refuge_id ="%03d" %  config[ 'refuge_id' ]
      loop do
        line = @sp.gets.chomp
        logger.debug("<< #{line}")
        case line
        when %r{@(\d\d\d)DNU}
          if $1 == refuge_id
            refugees_num = Family.sum(:num_of_members)
            @sp.puts "@#{refuge_id}UNU #{refugees_num}\r"
          end
        end
      end
    end
  end
end

config_path = File.expand_path('config.yml', File.dirname(__FILE__))
default_config = {
  root_path: root_path,
  'refuge_id' => 19,
  'serial_port' => '/dev/ttyACM0',
  'rails_env' => 'development'
}
config = default_config.merge(YAML.load_file(config_path))
se = ServerEngine.create(nil, ComServer, config)
se.run
