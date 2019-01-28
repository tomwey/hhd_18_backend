class CreateDailyChecks < ActiveRecord::Migration
  def change
    create_table :daily_checks do |t|
      t.boolean :has_man, null: false
      t.boolean :has_error
      t.text :memo, null: false
      t.integer :state, default: 0
      t.string :images, array: true, default: []
      t.date :check_on, null: false
      t.integer :house_id, index: true

      t.timestamps null: false
    end
  end
end
