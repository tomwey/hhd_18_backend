class AddPasswordDigestAndNameAndDeptToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :name, :string
    add_column :users, :dept, :string
  end
end
