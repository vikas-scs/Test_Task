class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :technology_name
      t.float :version

      t.timestamps
    end
  end
end
