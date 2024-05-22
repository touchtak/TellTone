class Request < ApplicationRecord

  belongs_to :viewer
  belongs_to :creator

  validates :body, presence: true

end
