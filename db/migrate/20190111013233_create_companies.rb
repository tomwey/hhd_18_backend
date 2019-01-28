class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :house_id
      t.string :name, null: false
      t.string :comp_type, null: false
      t.string :comp_xz_type, null: false
      t.string :mgr_level, null: false
      t.string :alias_name
      t.string :comp_no1
      t.string :comp_prop_type
      t.string :phone
      t.string :top_comp_type
      t.string :scope
      t.string :comp_no2
      t.boolean :has_video_monitor
      t.string :comp_no3
      t.date :reg_date
      t.string :reg_money
      t.date :fz_date
      t.date :expire_date
      t.string :reg_address
      t.string :address, null: false
      t.integer :state, default: 0

      t.timestamps null: false
    end
    add_index :companies, :house_id
  end
end
