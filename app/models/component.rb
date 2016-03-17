class Component < ActiveRecord::Base
  attr_accessor :type_name, :products_list
  attr_accessible :cost, :description, :name, :photo_id, :component_type_id, :type_name, :uploaded_photos, :products_list, :spec_component_type_id, :designation, :quantitative_measure_id

  
  
  belongs_to :component_type
  belongs_to :photo
  has_many :photos
  has_many :component_links
  has_many :planner_components
  has_many :warehouse_components
  
  after_save :make_component_links
  
  validates :name, :presence => {:message => "Поле 'Название' не должно быть пустым"},
				   :length => { :maximum => 60, :message => "Название не может быть длиннее 60-х знаков"}
  
  #validate :component_type_validation
  
  def make_component_links
	prdcts = Product.all
	cLink = []
	if products_list != nil and products_list != [] and prdcts != []
		prdcts.each do |p|
			val = products_list[p.id.to_s.to_sym].to_i
			cLink = p.component_links.where(:component_id => self.id).first
			if val == 0
				cLink.destroy if cLink != nil
			elsif val == 1
				p.component_links.create(:component_id => self.id) if cLink == nil
			end
		end
	end
  end

  def available_components #имеющиеся компоненты
	warehouse_components.where(:status_id => 1)
  end
  
  def required_components #необходимые компоненты
	warehouse_components.where(:status_id => 2)
  end
  
  def ordered_components #заказанные компоненты
	warehouse_components.where(:status_id => 3)
  end
  
  def in_planner_components_count
	c = 0
	if self.planner_components != []
		self.planner_components.each {|cmp| c += cmp.amount if cmp.amount != nil }
	end
	return c
  end
  
  def available_components_count #имеющиеся компоненты
	c = 0
	if self.available_components != []
		self.available_components.each {|cmp| c += cmp.amount if cmp.amount != nil }
	end
	return c
  end
  
  def required_components_count #имеющиеся компоненты
	c = 0
	if self.required_components != []
		self.required_components.each {|cmp| c += cmp.amount if cmp.amount != nil }
	end
	return c
  end
  
  def ordered_components_count #имеющиеся компоненты
	c = 0
	if self.ordered_components != []
		self.ordered_components.each {|cmp| c += cmp.amount if cmp.amount != nil }
	end
	return c
  end
  
  
  def component_type_validation
	if component_type_id == nil and type_name.strip == ''
		errors.add(:component_type, "Выберите тип компонента")
	end
  end
  
  def rur_cost
	(self.cost == 0.0 || self.cost == nil)? 'Цена не указана':(cost.to_s + ' рублей')
  end
  
  def uploaded_photos=(attrs)
	attrs.each {|attr| self.photos.build(:link => attr)}
  end
  
  def alter_photo
	if get_photo == nil
		return '/files/nophoto.jpg'
	else
		return get_photo.link
	end
  end
  
  def alter_photo_mini
	if get_photo == nil
		return '/files/nophoto_mini.jpg'
	else
		return get_photo.link.mini
	end
  end
  
  def get_photo
	p = nil
	if self.photo == nil
		if self.photos != []
			self.update_attribute(:photo_id, self.photos.first.id)
			p = self.photo
		end
	else
		p = self.photo
	end
	return p
  end
  
end
