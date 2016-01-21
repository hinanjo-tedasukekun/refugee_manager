class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title, null: false, default: ''
      t.text :content, null: false, default: ''

      t.timestamps null: false
    end
  end
end
