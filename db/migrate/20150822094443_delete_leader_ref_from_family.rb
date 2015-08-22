class DeleteLeaderRefFromFamily < ActiveRecord::Migration
  def change
    remove_column :families, :leader_id
  end
end
