class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :password, :string
    add_column :users, :address, :string
    add_column :users, :preferred_cousine, :string
  end
end
