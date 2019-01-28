class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :buildings, :name, unique: true
  end
end
