class CreateVulnerabilities < ActiveRecord::Migration
  def change
    create_table :vulnerabilities do |t|
      t.references :refugee, index: true, foreign_key: true
      t.integer :type_id

      t.timestamps null: false
    end

    add_index :vulnerabilities, :type_id
  end
end
