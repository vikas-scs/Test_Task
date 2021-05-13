class AddProjectTypeToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :project_type, :string
  end
end
