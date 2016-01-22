class CreateJoinTableFamilyLeader < ActiveRecord::Migration
  def change
    create_table :family_leaders do |t|
      t.integer :family_id
      t.integer :refugee_id
      t.index :family_id
      t.index :refugee_id
    end
  end
end
