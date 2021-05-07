class AddProjectRefToFiledet < ActiveRecord::Migration[6.1]
  def change
    add_reference :filedets, :project, null: false, foreign_key: true
  end
end
