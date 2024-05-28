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
  has_many :post_tag_relationships, dependent: :destroy
  has_many :post_tags, through: :post_tag_relationships

  validates :body, presence: true, length:{maximum:140}

  # 検索用
  def self.looks(search, word)
    creator_posts = CreatorPost.where("body LIKE?","%#{word}%")
    @post = creator_posts.select { |creator_post| creator_post.post_image.attached? || creator_post.audio.present? }
  end

  # 投稿をいいねしているか判定する
  def liked?(user)
     likes.where(user_id: user.id).exists?
  end

  # いいね数カウント
  def like_count(creator_post)
      likes.where(creator_post_id: creator_post.id).count
  end

  # タグ付け用
  def save_post_tags(tags)
    current_tags = self.post_tags.pluck(:name) unless self.post_tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.post_tags.delete PostTag.find_by(name:old_name)
    end

    new_tags.each do |new_name|
      post_tag = PostTag.find_or_create_by(name:new_name)
      self.post_tags << post_tag
    end
  end

end
