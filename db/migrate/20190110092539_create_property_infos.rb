class CreatePropertyInfos < ActiveRecord::Migration
  def change
    create_table :property_infos do |t|
      t.string :_type, null: false
      t.integer :house_id, null: false
      t.string :license_no
      t.string :comp_name
      t.string :comp_phone
      t.string :comp_addr
      t.string :comp_position
      t.string :card_type
      t.string :card_no
      t.string :name
      t.string :sex
      t.string :nation
      t.string :phone
      t.string :address
      t.string :serv_space
      t.string :memo
      t.integer :state, default: 0

      t.timestamps null: false
    end
    add_index :property_infos, :house_id
  end
end
