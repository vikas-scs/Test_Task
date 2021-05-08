class DropListToProject < ActiveRecord::Migration[6.1]
  def change
  	remove_column :projects, :repository_version
  	remove_column :projects, :technology
  end
end
