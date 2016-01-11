class CreateRefugeeAllergens < ActiveRecord::Migration
  def change
    create_table :refugee_allergens do |t|
      t.references :refugee, index: true, foreign_key: true
      t.references :allergen, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
