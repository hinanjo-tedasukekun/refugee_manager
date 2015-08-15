class CreateRefugees < ActiveRecord::Migration
  def change
    create_table :refugees do |t|
      # $B:_<<$7$F$$$k$+$I$&$+(B
      t.boolean :presence, null: false, default: true
      # $BL>A0(B
      t.string :name, null: false, limit: 64, default: ''
      # $B$U$j$,$J(B
      t.string :furigana, null: false, limit: 64, default: ''
      # $B@-JL(B
      t.integer :gender, null: false, limit: 1, default: 0
      # $BG/Np(B
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
