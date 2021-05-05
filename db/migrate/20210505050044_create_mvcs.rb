class CreateMvcs < ActiveRecord::Migration[6.1]
  def change
    create_table :mvcs do |t|
      t.integer :models_count
      t.integer :controllers_count
      t.integer :views_count
       
      t.timestamps
    end
  end
end
