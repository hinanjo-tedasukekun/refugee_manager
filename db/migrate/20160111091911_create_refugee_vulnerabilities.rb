class CreateRefugeeVulnerabilities < ActiveRecord::Migration
  def change
    drop_table :vulnerability_types

    create_table :refugee_vulnerabilities do |t|
      t.references :refugee, foreign_key: true
      t.references :vulnerability, foreign_key: true

      t.timestamps null: false

      t.index :refugee_id, name: :refugee_vul_refugee_id
      t.index :vulnerability_id, name: :refugee_vul_vulnerability_id
    end
  end
end
