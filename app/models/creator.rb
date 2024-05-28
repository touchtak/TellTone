class Creator < ApplicationRecord

  has_one_attached :creator_icon

  has_many :requests

  # フォロー機能
  # クリエイターリレーション
  has_many :reverse_of_creator_relationships, class_name: "CreatorRelationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面用
  has_many :creator_followers, through: :reverse_of_creator_relationships, source: :follower

  belongs_to :user

  validates :name, presence: true, length:{maximum:20}
  validates :introduction, length:{maximum:140}

  # アイコン表示
  def get_creator_icon
    if creator_icon.attached?
      creator_icon
    else
      'no_image.jpg'
    end
  end

  # 検索時の処理
  def self.looks(search, word)
    @creator = Creator.where("name LIKE?","%#{word}%")
  end

end
