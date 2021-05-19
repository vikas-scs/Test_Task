class ModifyToRepository < ActiveRecord::Migration[6.1]
  def change
  	remove_column :repositories, :version
  	add_column :repositories, :version, :string
  end
end
