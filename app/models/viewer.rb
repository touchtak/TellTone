class Viewer < ApplicationRecord

  has_one_attached :viewer_icon

  # <フォロー機能>
  # クリエイターリレーション
  has_many :creator_relationships, class_name: "CreatorRelationship", foreign_key: "follower_id", dependent: :destroy
  # ビューワーリレーション
  has_many :viewer_relationships, class_name: "ViewerRelationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_viewer_relationships, class_name: "ViewerRelationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面用
  has_many :viewer_followers, through: :reverse_of_viewer_relationships, source: :follower
  has_many :creator_followings, through: :creator_relationships, source: :followed
  has_many :viewer_followings, through: :viewer_relationships, source: :followed

  belongs_to :user

  validates :name, presence: true

  # アイコン表示
  def get_viewer_icon
    if viewer_icon.attached?
      viewer_icon
    else
      'no_image.jpg'
    end
  end

  # 検索時の処理
  def self.looks(search, word)
    @viewer = Viewer.where("name LIKE?","%#{word}%")
  end

  # フォローしているか判定
  def creator_following?(creator)
    creator_followings.include?(creator)
  end

  def viewer_following?(viewer)
    viewer_followings.include?(viewer)
  end

end
