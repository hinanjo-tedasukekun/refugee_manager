class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name, limit: 32, null: false, default: ''

      t.timestamps null: false
    end
    add_index :skills, :name, unique: true
  end
end
