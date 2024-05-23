class PostTag < ApplicationRecord

  has_many :post_tag_relationships, dependent: :destroy
  has_many :viewer_posts, through: :post_tag_relationships
  has_many :creator_posts, through: :post_tag_relationships

  validates :name, presence:true, length:{maximum:50}

end
