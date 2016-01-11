class CreateRefugeeSupplies < ActiveRecord::Migration
  def change
    create_table :refugee_supplies do |t|
      t.references :refugee, index: true, foreign_key: true
      t.references :supply, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
