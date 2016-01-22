# 標準入力から受け取った世帯の情報をデータベースへ登録する

require 'active_record'
require 'active_support/core_ext/object/with_options'
require 'yaml'

root_path = File.expand_path('../..', File.dirname(__FILE__))
$LOAD_PATH.unshift("#{root_path}/app")
$LOAD_PATH.unshift("#{root_path}/lib")

require 'models/family'
require 'models/refugee'
require 'models/leader_family'
require 'models/check_digit_validator'
require 'models/barcode'

config_path = File.expand_path('config.yml', File.dirname(__FILE__))
default_config = {
  'shelter_id' => 19,
  'rails_env' => 'development'
}
config = default_config.merge(YAML.load_file(config_path))
shelter_id = config['shelter_id']

puts("避難所番号: #{shelter_id}")

# データベースへの接続
Dir.chdir(root_path)
rails_env = config['rails_env']
db_config = YAML.load_file('config/database.yml')[rails_env]
ActiveRecord::Base.establish_connection(db_config)

puts("データベースに接続完了: #{rails_env} 環境")

# 無効なコマンド表示
def print_invalid_command(line)
  puts("#{line}: 無効なコマンドです")
end

# 未登録表示
def print_refugee_not_found(refugee_num)
  puts("#{refugee_num}: 情報が登録されていません")
end

# エラー表示
def print_error(line)
  puts("#{line}: 登録できませんでした")
end

# 世帯のデータを登録する
def insert_family_data(leader_id, num_of_members)
  ActiveRecord::Base.transaction do
    family = Family.create!(num_of_members: num_of_members)
    refugee = Refugee.create!(id: leader_id, family: family)
    FamilyLeader.create!(family: family, refugee: refugee)
  end

  puts("登録しました: 代表者番号 #{leader_id}, 世帯人数 #{num_of_members}")
end

# 世帯のデータを更新する
def update_family_data(leader, num_of_members)
  ActiveRecord::Base.transaction do
    family = leader.family
    family.num_of_members = num_of_members
    family.save!
  end

  puts("更新しました: 代表者番号 #{leader.id}, 世帯人数 #{num_of_members}")
end

# 在室状況を更新する
def update_refugee_presence(refugee, presence)
  ActiveRecord::Base.transaction do
    refugee.presence = presence
    refugee.save!
  end

  puts("更新しました: 番号 #{refugee.id}, #{presence ? '入室' : '退室'}")
end

%i(INT TERM).each do |signal|
  Signal.trap(signal) do
    # 割り込みを捕捉したら終了する
    exit
  end
end

# 接続確認のパターン
CONNECT_PATTERN = 'C'
# 世帯の人数のパターン
FAMILY_DATA_PATTERN = /\A# ([0-9]{8}) ([0-9]{1,2})\z/
# 入退室情報のパターン
PRESENCE_PATTERN = /\AP ([0-9]{8}) ([01])\z/
# 終了のパターン
QUIT_PATTERN = /\Aq(?:uit)?\z/i

# メインループ：1 行ずつ読み込む
loop do
  print('> ')
  line = gets
  break unless line
  line.chomp!

  case line
  when QUIT_PATTERN
    exit
  when CONNECT_PATTERN
    puts('A')
  when FAMILY_DATA_PATTERN
    m = Regexp.last_match

    # バーコード
    barcode = Barcode.new(code: m[1])
    unless barcode.valid? && barcode.shelter_id == shelter_id
      # 無効なバーコードまたは避難所番号が異なる場合
      print_error(line)
      next
    end

    # 代表者番号
    leader_id = barcode.refugee_id
    # 世帯の人数
    num_of_members = m[2].to_i

    leader = FamilyLeader.find_by(refugee_id: leader_id)
    begin
      if leader
        # 代表者が登録されていれば情報を更新する
        update_family_data(leader, num_of_members)
      else
        # 代表者が登録されていなければ情報を登録する
        insert_family_data(leader_id, num_of_members)
      end
    rescue
      print_error(line)
      next
    end
  when PRESENCE_PATTERN
    m = Regexp.last_match

    # バーコード
    barcode = Barcode.new(code: m[1])
    unless barcode.valid? && barcode.shelter_id == shelter_id
      # 無効なバーコードまたは避難所番号が異なる場合
      print_error(line)
      next
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    unless refugee
      print_refugee_not_found(barcode.code)
    end

    begin
      update_refugee_presence(refugee, m[2] == '1')
    rescue
      print_error(line)
      next
    end
  else
    print_invalid_command(line)
  end
end
