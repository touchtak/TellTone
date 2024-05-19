class Request < ApplicationRecord
  
  has_one_attached :request_image

  belongs_to :viewer
  belongs_to :creator

end
