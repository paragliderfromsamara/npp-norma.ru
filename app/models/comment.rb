class Comment < ActiveRecord::Base
  attr_accessible :from, :link, :product_id, :link_cache
 
  belongs_to :product
  
  mount_uploader :link, CommentUploader
end
