class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :image, null: false
      t.string :house_use, array: true, default: []
      t.string :_type
      t.string :jg_type
      t.string :plot_name
      t.string :area
      t.integer :rooms_count
      t.string :mgr_level, null: false
      t.string :use_type, null: false
      t.string :rent_type
      t.string :mgr_reason
      t.text :memo

      t.timestamps null: false
    end
  end
end
