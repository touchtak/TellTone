class CreatorPost < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :creator
  has_one :post_numbering, dependent: :destroy
  has_one :emotion

  has_many :comments, dependent: :destroy
  has_many :tag_relationships

  validates :body, presence: true

  def self.looks(search, word)
    creator_post = CreatorPost.where("body LIKE?","%#{word}%")
    @post = creator_post.select { |creator_post| creator_post.post_image.attached? }
  end

end
