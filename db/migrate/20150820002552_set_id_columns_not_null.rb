class SetIdColumnsNotNull < ActiveRecord::Migration
  def change
    change_column_null :families, :leader_id, false
    change_column_null :refugees, :family_id, false
  end
end
