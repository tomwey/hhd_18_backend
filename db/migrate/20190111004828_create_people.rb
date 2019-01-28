class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :card_type, null: false
      t.string :card_no,   null: false
      t.date :birth, null: false
      t.string :country, null: false
      t.string :name, null: false
      t.string :sex, null: false
      t.string :reg_address
      t.string :address1, null: false
      t.string :mgr_level, null: false
      t.string :caiji_type, null: false
      t.string :caiji_reason, null: false
      t.string :situation
      t.string :birth_addr
      t.string :native_place
      t.string :identity
      t.string :old_name
      t.string :nation
      t.string :alias_name
      t.string :telephone
      t.string :marry_status
      t.string :gov_type
      t.string :religion
      t.string :height
      t.string :blood_type
      t.string :mili_serve_state
      t.string :education
      t.string :speciality
      t.string :job
      t.string :strong_point
      t.integer :house_id, index: true
      t.integer :state, default: 0

      t.timestamps null: false
    end
  end
end
