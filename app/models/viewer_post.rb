class ViewerPost < ApplicationRecord

  has_one_attached :post_image

  belongs_to :user
  belongs_to :viewer
  has_one :post_numbering, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :tag_relationships

  validates :body, presence: true

end
