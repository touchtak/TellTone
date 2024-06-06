class PostNumbering < ApplicationRecord

  belongs_to :viewer_post, optional: true
  belongs_to :creator_post, optional: true

end
