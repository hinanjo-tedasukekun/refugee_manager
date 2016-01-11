class RenameTablesRelatedToVulnerabilities < ActiveRecord::Migration
  def change
    drop_table :vulnerabilities

    create_table :vulnerabilities do |t|
      t.string :name, null: false, limit: 32, default: ''
      t.timestamps null: false
    end
  end
end
