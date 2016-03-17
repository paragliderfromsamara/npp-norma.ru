class UnitProductLink < ActiveRecord::Base
  attr_accessible :product_id, :unit_id, :amount
  belongs_to :product
  belongs_to :unit
end
