class Viewer < ApplicationRecord

  has_one_attached :viewer_icon

  belongs_to :user

  def get_viewer_icon
    if viewer_icon.attached?
      viewer_icon
    else
      'no_image.jpg'
    end
  end
end
