class Project < ApplicationRecord
	belongs_to :user
	has_one :mvc
	has_many :filedets
	has_many :technology_versions
	validates :name, presence: true
	validates :name, uniqueness: true
	validates :github_url, :format => { :with =>/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,:multiline => true, :message => "invalid git_hub url" }
end
