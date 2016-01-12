class AddOtherAllergensToRefugees < ActiveRecord::Migration
  def change
    add_column :refugees, :other_allergens, :string, null: false, default: ''
  end
end
