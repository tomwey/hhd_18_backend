class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :units, :name, unique: true
  end
end
