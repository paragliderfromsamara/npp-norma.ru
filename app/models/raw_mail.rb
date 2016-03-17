class RawMail < ActiveRecord::Base
  attr_accessible :message_id, :link
  belongs_to :message

end