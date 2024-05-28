class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :viewer, dependent: :destroy
  has_one :creator, dependent: :destroy

  has_many :viewer_posts, dependent: :destroy
  has_many :creator_posts, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length:{maximum:20}

end
