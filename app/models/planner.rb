class Planner < ActiveRecord::Base
  attr_accessor :products_list
  attr_accessible :finish_date, :pl_id, :products_list
  has_many :planner_devices
  has_many :planner_components
  before_create :setPlannerId
  after_save :make_planner_product_links
  
  def setPlannerId
	self.pl_id = Planner.count + 1 
  end
  
  def make_planner_product_links
	prdcts = Product.all
	pLink = []
	if products_list != nil and products_list != [] and prdcts != []
		prdcts.each do |p|
			val = products_list[p.id.to_s.to_sym].to_i
			pLink = p.planner_devices.where(:planner_id => self.id).first
			if val == 0
				pLink.destroy if pLink != nil
			elsif val > 0
				if pLink == nil
					p.planner_devices.create(:planner_id => self.id, :amount => val)
				else
					pLink.update_attribute(:amount, val) if pLink.amount != val
				end
			end
		end
	end
  end
  
  def calculate_planner_components
	if self.planner_devices != []
		create_planner_components if self.planner_components == []
		update_planner_components if self.planner_components != []
	else
		destroy_planner_components
	end
  end
  
  def create_planner_components
	ucArray = []
	self.planner_devices.each do |d|
		upLinks = d.product.unit_product_links
		if upLinks != []
			upLinks.each do |upl|
				ucLinks = upl.unit.unit_component_links
				if ucLinks != []
					ucLinks.each do |ucl|
						number_of = ucl.number*d.amount
						setPlannerComponent(number_of, ucl.component_id)
					end
				end
			end
		end
	end
  end
  
  def setPlannerComponent(newAmount, component_id)
	planner_component = self.planner_components.where(:component_id => component_id).first
	if planner_component == nil
		self.planner_components.create(:amount => newAmount, :component_id => component_id)
	else
		newAmount = planner_component.amount + newAmount
		planner_component.update_attribute(:amount, newAmount)
	end
  end
  
  def update_planner_components
	clear_planner_components
	create_planner_components
	remove_null_amount_components
  end
  
  def remove_null_amount_components
	pComponents = self.planner_components.where(:amount => 0)
	if pComponents != []
		pComponents.each {|c| c.destroy}
	end
  end
  
  def clear_planner_components
	self.planner_components.each {|c| c.update_attribute(:amount, 0)}
  end
  
  def destroy_planner_components
	if self.planner_components != []
		self.planner_components.each {|c| c.destroy}
	end
  end
end
