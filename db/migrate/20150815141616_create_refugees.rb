class CreateRefugees < ActiveRecord::Migration
  def change
    create_table :refugees do |t|
      # 在室しているかどうか
      t.boolean :presence, null: false, default: true
      # 名前
      t.string :name, null: false, limit: 64, default: ''
      # ふりがな
      t.string :furigana, null: false, limit: 64, default: ''
      # 性別
      t.integer :gender, null: false, limit: 1, default: 0
      # 年齢
      t.integer :age

      t.timestamps null: false
    end

    add_index :refugees, :presence
    add_index :refugees, :name
    add_index :refugees, :furigana
    add_index :refugees, :gender
    add_index :refugees, :age
  end
end
