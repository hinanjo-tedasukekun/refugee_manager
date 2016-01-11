class CreateAllergens < ActiveRecord::Migration
  def change
    create_table :allergens do |t|
      t.string :name, limit: 32, null: false, default: ''

      t.timestamps null: false
    end
    add_index :allergens, :name, unique: true
  end
end
