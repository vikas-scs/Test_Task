class RenameOldTableToNewTable < ActiveRecord::Migration[6.1]
  def change
  	rename_table :repositories, :technology_version
  end
end
