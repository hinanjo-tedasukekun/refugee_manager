class AddPasswordDigestToRefugees < ActiveRecord::Migration
  def change
    add_column :refugees, :use_password, :boolean
    add_column :refugees, :password_digest, :string
  end
end
