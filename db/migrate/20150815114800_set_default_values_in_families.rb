class SetDefaultValuesInFamilies < ActiveRecord::Migration
  def change
    change_column_default :families,  :address, ''
    change_column_default :families, :postal_code, ''
  end
end
