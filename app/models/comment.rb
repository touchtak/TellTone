class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :viewer
  belongs_to :viewer_post
  belongs_to :creator_post

  validates :comment, presence: true

end
