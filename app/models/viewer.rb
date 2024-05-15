class Viewer < ApplicationRecord

  has_one_attached :viewer_icon

  belongs_to :user

  validates :name, presence: true

  def get_viewer_icon
    if viewer_icon.attached?
      viewer_icon
    else
      'no_image.jpg'
    end
  end
  
  def self.looks(search, word)
    @viewer = Viewer.where("name LIKE?","%#{word}%")
  end
  
end
