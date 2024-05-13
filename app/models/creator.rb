class Creator < ApplicationRecord

  has_one_attached :creator_icon

  belongs_to :user

  validates :name, presence: true

  def get_creator_icon
    if creator_icon.attached?
      creator_icon
    else
      'no_image.jpg'
    end
  end

  def self.looks(search, word)
    @creator = Creator.where("name LIKE?","%#{word}%")
  end

end
