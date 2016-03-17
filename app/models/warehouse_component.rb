class WarehouseComponent < ActiveRecord::Base
  attr_accessible :amount, :component_id, :cost, :device_id, :status_id
end
