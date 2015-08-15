class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      # 家族の人数
      t.integer :num_of_members, null: false
      # 在宅避難かどうか
      t.integer :at_home, null: false, default: 0, limit: 1
      # 住所
      t.string :address, null: false
      # 郵便番号
      t.string :postal_code, null: false, limit: 7

      t.timestamps null: false
    end

    add_index :families, :num_of_members
    add_index :families, :at_home
  end
end
