class ComponentLink < ActiveRecord::Base
  attr_accessible :component_id, :product_id
  
  belongs_to :product
  belongs_to :component
end
