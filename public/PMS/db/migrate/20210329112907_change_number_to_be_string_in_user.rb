class ChangeNumberToBeStringInUser < ActiveRecord::Migration[6.1]
  def change
  	remove_column :users, :mobile, :integer
  	add_column :users, :mobile, :string
  end
end
