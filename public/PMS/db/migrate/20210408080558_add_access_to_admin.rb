class AddAccessToAdmin < ActiveRecord::Migration[6.1]
  def change
  	add_column :admins, :read_privileges, :string, array: true, default: []
  	add_column :admins, :write_privileges, :string, array: true, default: []
  	add_column :admins, :delete_privileges, :string, array: true, default: []
  	add_column :admins, :create_privileges, :string, array: true, default: []
  end
end
