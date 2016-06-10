class ComponentLink < ActiveRecord::Base
  attr_accessible :component_id, :product_id
  
  belongs_to :product
  belongs_to :component
  
  def self.optimize
    ComponentLink.all.each do |cl|
        cl.delete if cl.component.nil? || cl.product.nil? 
    end
  end
end
