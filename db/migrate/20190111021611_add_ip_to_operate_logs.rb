class AddIpToOperateLogs < ActiveRecord::Migration
  def change
    add_column :operate_logs, :ip, :string
  end
end
