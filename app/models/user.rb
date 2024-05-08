class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :viewer
  has_one :creaer
  
  has_many :viewer_posts
  has_many :creater_posts

  validates :name, presence: true, uniqueness: true
end
