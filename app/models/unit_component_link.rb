class UnitComponentLink < ActiveRecord::Base
  attr_accessible :component_id, :number, :unit_id
  belongs_to :unit
  belongs_to :component
  
  validate :component_type_validation
  def component_type_validation
	if component_id == nil || unit_id == nil || unit_id == '' || component_id == '' || unit_id == 0 || component_id == 0
		errors.add(:component_id, "Невозможно привязать компонент к узлу")
	end
  end
end
