class ViewerPost < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :viewer

  has_one :post_numbering

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tag_relationships

  validates :body, presence: true

  def self.looks(search, word)
    @post = ViewerPost.where("body LIKE?","%#{word}%")
  end

  def liked?(user)
     likes.where(user_id: user.id).exists?
  end

end
