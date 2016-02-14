class CreateShelters < ActiveRecord::Migration
  def change
    create_table :shelters do |t|
      t.integer :num, default: 1, null: false, index: true
      t.string :name, default: 'ポリテクカレッジ浜松', null: false
      t.string :postal_code, limit: 7, default: '', null: false
      t.string :address, default: '', null: false

      t.timestamps null: false
    end
  end
end
