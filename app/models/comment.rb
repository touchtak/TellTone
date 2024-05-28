class Comment < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :viewer
  belongs_to :viewer_post, optional: true
  belongs_to :creator_post, optional: true

  validates :comment, presence: true, length:{maximum:140}

end
