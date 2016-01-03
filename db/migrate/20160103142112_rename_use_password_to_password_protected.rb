class RenameUsePasswordToPasswordProtected < ActiveRecord::Migration
  def change
    rename_column :refugees, :use_password, :password_protected
  end
end
