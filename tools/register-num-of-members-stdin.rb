# 標準入力から受け取った家族の情報をデータベースへ登録する

# 避難所番号（この避難所番号のデータの登録のみ有効になる）
REFUGE_ID = 19

require 'active_record'
require 'yaml'

root_path = File.expand_path('..', File.dirname(__FILE__))
$LOAD_PATH.unshift("#{root_path}/app")
$LOAD_PATH.unshift("#{root_path}/lib")

require 'models/family'
require 'models/refugee'
require 'models/leader'
require 'refugee_manager/bar_code'

# データベースへの接続
Dir.chdir(root_path)
db_config = YAML.load_file('config/database.yml')['development']
ActiveRecord::Base.establish_connection(db_config)

# エラー表示
def print_error(line)
  puts("#{line}: 登録できませんでした")
end

# 家族のデータを登録する
def insert_family_data(leader_id, num_of_members)
  ActiveRecord::Base.transaction do
    family = Family.create!(num_of_members: num_of_members)
    refugee = Refugee.create!(id: leader_id, family: family)
    Leader.create!(family: family, refugee: refugee)
  end

  puts("登録しました: 代表者番号 #{leader_id}, 家族人数 #{num_of_members}")
end

# 家族のデータを更新する
def update_family_data(leader, num_of_members)
  ActiveRecord::Base.transaction do
    family = leader.family
    family.num_of_members = num_of_members
    family.save!
  end

  puts("更新しました: 代表者番号 #{leader.id}, 家族人数 #{num_of_members}")
end

# メインループ：1 行ずつ読み込む
while line = gets
  line.chomp!

  unless /\A\d{8},\d{1,2}\z/ === line
    # 行の形式が異なる場合
    print_error(line)
    next
  end

  data = line.split(',')

  # バーコード
  bar_code = RefugeeManager::BarCode.new(data[0])
  unless bar_code.valid? && bar_code.refuge_id == REFUGE_ID
    # 無効なバーコードまたは避難所番号が異なる場合
    print_error(line)
    next
  end

  # 代表者番号
  leader_id = bar_code.refugee_id
  # 家族の人数
  num_of_members = data[1].to_i

  leader = Leader.find_by(id: leader_id)
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
end
