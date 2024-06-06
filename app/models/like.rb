class Like < ApplicationRecord

  belongs_to :user
  belongs_to :viewer_post, optional: true
  belongs_to :creator_post, optional: true

end
