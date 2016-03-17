class Photo < ActiveRecord::Base
  attr_accessible :link, :product_id, :description
  belongs_to :product
  belongs_to :component

  mount_uploader :link, PhotoUploader
end
