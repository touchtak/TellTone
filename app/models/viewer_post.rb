class ViewerPost < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :viewer
  has_one :post_numbering

  has_many :comments
  has_many :tag_relationships

  validates :body, presence: true

end
