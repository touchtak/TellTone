class PostTagRelationship < ApplicationRecord

  belongs_to :post_tag
  belongs_to :viewer_post, optional: true
  belongs_to :creator_post, optional: true

end
