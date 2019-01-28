class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.integer :merch_id
      t.string :logo,  null: false
      t.string :name,  null: false
      t.string :lic_no, null: false
      t.string :lic_images, array: true, default: []
      t.string :_type, null: false
      t.string :phone, null: false
      t.string :address
      t.string :intro
      t.integer :balance, default: 0
      t.string :state, default: 'pending'
      t.datetime :vip_expired_at
      
      t.timestamps null: false
    end
    add_index :merchants, :merch_id, unique: true
  end
end
