class Project < ApplicationRecord
	belongs_to :user
	has_one :mvc
	has_many :fildets
end
