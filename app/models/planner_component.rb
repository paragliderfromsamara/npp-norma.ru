class PlannerComponent < ActiveRecord::Base
  attr_accessible :amount, :component_id, :planner_id
  belongs_to :planner
  belongs_to :component
end
