class ChangeColumnForDailyChecks < ActiveRecord::Migration
  def change
    remove_column :daily_checks, :has_man
    remove_column :daily_checks, :has_error
    add_column :daily_checks, :has_man, :string
    add_column :daily_checks, :has_error, :string
  end
end
