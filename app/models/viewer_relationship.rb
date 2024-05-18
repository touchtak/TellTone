class ViewerRelationship < ApplicationRecord

  belongs_to :follower, class_name: "Viewer"
  belongs_to :followed, class_name: "Viewer"

end
