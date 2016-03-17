class Attachment < ActiveRecord::Base
  attr_accessible :message_id, :name, :link
  belongs_to :message

end