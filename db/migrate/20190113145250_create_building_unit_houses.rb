class CreateBuildingUnitHouses < ActiveRecord::Migration
  def change
    create_table :building_unit_houses do |t|
      t.integer :address_id, null: false
      t.integer :building_id, null: false
      t.integer :unit_id
      t.string :room_no
      t.integer :house_id, null: false

      t.timestamps null: false
    end
    add_index :building_unit_houses, :address_id
    add_index :building_unit_houses, :building_id
    add_index :building_unit_houses, :unit_id
    add_index :building_unit_houses, :house_id
  end
end
