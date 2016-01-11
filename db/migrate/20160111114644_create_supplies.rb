class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name, limit: 32, null: false, default: ''

      t.timestamps null: false
    end
    add_index :supplies, :name, unique: true
  end
end
