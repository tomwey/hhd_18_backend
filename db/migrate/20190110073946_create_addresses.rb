class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name, null: false
      t.string :addr_id, null: false, index: true, unique: true
      t.string :parent_addr
      t.string :district
      t.string :police
      t.string :local_psb
      t.integer :house_id, index: true

      t.timestamps null: false
    end
  end
end
