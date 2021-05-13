class AddImageToUser < ActiveRecord::Migration[6.1]
   def self.up
  	add_column :users, :image_file_name, :string
  	add_column :users, :image_content_type, :string
    add_column :users, :image_file_size, :integer
    add_column :users, :image_uploaded_at, :datetime
  end
  def self.down
  	remove_column :users, :image_file_name
  	remove_column :users, :image_content_type
    remove_column :users, :image_file_size
    remove_column :users, :image_uploaded_at
  end
end

