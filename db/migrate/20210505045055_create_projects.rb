class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :github_url
      t.string :repository_version
      t.string :technology
      t.timestamps
    end
  end
end
