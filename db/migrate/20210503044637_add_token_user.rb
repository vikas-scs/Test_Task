class AddTokenUser < ActiveRecord::Migration[6.1]
  def change
  	add_column :users, :token, :integer
  end
end
