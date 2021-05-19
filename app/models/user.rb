class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_many :projects
   validates :mobile, presence: :true
   validates :first_name, presence: :true, format: { with: /\A[a-zA-Z]+\z/}
   validates :last_name, presence: :true, format: { with: /\A[a-zA-Z]+\z/}
   validates :mobile, format: { with: /\A[6-9]{1}\d{9}\z/ }, allow_blank: true
end
