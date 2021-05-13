class Attachment < ApplicationRecord
	belongs_to :project, optional: true
	has_attached_file :image, styles: { medium: "100x100>", thumb: "100x100>" }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
