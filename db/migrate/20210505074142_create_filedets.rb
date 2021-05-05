class CreateFiledets < ActiveRecord::Migration[6.1]
  def change
    create_table :filedets do |t|
      t.string :file_name
      t.integer :lines_count
      t.integer :words_count
      t.integer :letter_count
      t.integer :spaces_count

      t.timestamps
    end
  end
end
