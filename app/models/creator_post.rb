class CreatorPost < ApplicationRecord

  # 画像・音声ファイル
  has_one_attached :post_image
  mount_uploader :audio, AudiofileUploader

  belongs_to :user
  belongs_to :creator

  has_one :post_numbering, dependent: :destroy
  has_one :emotion

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tag_relationships

  validates :body, presence: true

  def self.looks(search, word)
    creator_post = CreatorPost.where("body LIKE?","%#{word}%")
    @post = creator_post.select { |creator_post| creator_post.post_image.attached? }
  end

  def liked?(user)
     likes.where(user_id: user.id).exists?
  end

end
