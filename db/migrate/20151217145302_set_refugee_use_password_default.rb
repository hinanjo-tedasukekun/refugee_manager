class SetRefugeeUsePasswordDefault < ActiveRecord::Migration
  def change
    change_column_null :refugees, :use_password, false
    change_column_default :refugees, :use_password, false
  end
end
