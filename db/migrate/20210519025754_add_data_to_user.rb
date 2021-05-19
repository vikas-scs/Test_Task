class AddDataToUser < ActiveRecord::Migration[6.1]
  def change
  	remove_column :users, :token
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :mobile, :integer
  end
end
