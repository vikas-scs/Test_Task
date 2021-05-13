class AddProjectRefToAttachments < ActiveRecord::Migration[6.1]
  def change
    add_reference :attachments, :project, null: false, foreign_key: true
  end
end
