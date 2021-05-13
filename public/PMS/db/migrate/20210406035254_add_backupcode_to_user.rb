class AddBackupcodeToUser < ActiveRecord::Migration[6.1]
  def change
  	add_column :users, :backup_tmp, :string
  end
end
