class User < ApplicationRecord
	attr_accessor :gauth_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :google_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :lockable,:trackable, :timeoutable
  belongs_to :organization
  validates :name, format: { with: /\A[a-zA-Z]+\z/}
  validates :mobile, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :mobile, format: { with: /\A[6-9]{1}\d{9}\z/ }, allow_blank: true
  # validates :password, :format => {:with => /(?=.*[a-z])(?=.*[A-Z])(?=.*[., +, *, ?, ^, $, (, ), [, ], {, }, |,@])(?=.*[0-9]).{6,}/}
  has_many :projects
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
