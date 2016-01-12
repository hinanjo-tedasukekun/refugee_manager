class CreateRefugeeSkills < ActiveRecord::Migration
  def change
    create_table :refugee_skills do |t|
      t.references :refugee, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
