class CreateHouseUses < ActiveRecord::Migration
  def change
    create_table :house_uses do |t|
      t.string :name, null: false
      t.integer :_type, null: false
      t.integer :subtype, null: false

      t.timestamps null: false
    end
  end
end
