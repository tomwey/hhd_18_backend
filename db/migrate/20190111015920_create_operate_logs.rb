class CreateOperateLogs < ActiveRecord::Migration
  def change
    create_table :operate_logs do |t|
      t.integer :house_id
      t.string :title, null: false
      t.string :action, null: false
      t.references :operateable, polymorphic: true, index: true
      t.datetime :begin_time
      t.datetime :end_time
      t.integer :owner_id, index: true

      t.timestamps null: false
    end
    add_index :operate_logs, :house_id
  end
end
