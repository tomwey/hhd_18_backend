class AddStateToDailyChecks < ActiveRecord::Migration
  def change
    add_column :daily_checks, :name, :string
  end
end
