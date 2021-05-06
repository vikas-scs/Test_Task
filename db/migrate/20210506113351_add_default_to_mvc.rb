class AddDefaultToMvc < ActiveRecord::Migration[6.1]
  def change

  	add_column :mvcs, :models_list, :string, array: true
  	add_column :mvcs, :controllers_list,:string, array: true
  	add_column :mvcs, :views_list,:string, array: true
  end
end
