class AddStateToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :state, :integer, default: 0
  end
end
