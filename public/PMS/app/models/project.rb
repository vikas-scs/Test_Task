class Project < ApplicationRecord
	belongs_to :user, optional: true
	has_many :tasks
	has_many :attachments
	enum type: [:FullProjrct, :MiniProject, :Practice]
end
