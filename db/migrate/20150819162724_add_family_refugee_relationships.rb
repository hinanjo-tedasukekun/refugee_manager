class AddFamilyRefugeeRelationships < ActiveRecord::Migration
  def change
    add_reference :refugees, :family, index: true
    add_column :families, :leader_id, :integer

    add_index :families, :leader_id
  end
end
