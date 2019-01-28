class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :card_type, null: false
      t.string :card_no, null: false
      t.string :name, null: false
      t.string :sex, null: false
      t.date :birth, null: false
      t.string :nation, null: false
      t.string :country, null: false
      t.string :native_place
      t.string :job_type, null: false
      t.string :dept
      t.string :position
      t.string :telephone
      t.string :communicate_type
      t.string :contact_type
      t.string :begin_date
      t.string :end_date
      t.string :caiji_type, null: false
      t.string :caiji_reason, null: false
      t.string :address
      t.text :memo
      t.integer :company_id

      t.timestamps null: false
    end
    add_index :employees, :company_id
  end
end
