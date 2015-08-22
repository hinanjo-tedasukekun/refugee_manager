class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
      t.references :family, null: false, foreign_key: true
      t.references :refugee, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :leaders, :family_id, unique: true
    add_index :leaders, :refugee_id, unique: true
  end
end
