class Project < ApplicationRecord
	belongs_to :user
	has_one :mvc
	has_many :fildets
	has_many :technology_versions
end
