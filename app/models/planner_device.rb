class PlannerDevice < ActiveRecord::Base
  attr_accessible :amount, :planner_id, :product_id
  belongs_to :planner
  belongs_to :product
  
end
