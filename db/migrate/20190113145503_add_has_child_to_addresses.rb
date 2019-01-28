class AddHasChildToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :has_child, :boolean, default: false
  end
end
