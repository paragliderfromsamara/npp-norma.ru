class Unit < ActiveRecord::Base
  attr_accessor :products_list
  attr_accessible :description, :full_name, :name, :products_list
  has_many :unit_product_links, :dependent => :delete_all
  has_many :unit_component_links, :dependent => :delete_all
  
  after_save :make_unit_product_links
  
   validates :name, :presence => {:message => "Поле 'Наименование' не должно быть пустым"},
				    :length => { :maximum => 60, :message => "Наименование не может быть длиннее 60-х знаков"},
				    :uniqueness => {:message => "Компонент с таким наименованием уже существует"}
  
  def make_unit_product_links #привязывает узел к прибору
	prdcts = Product.all
	cLink = []
	if products_list != nil and products_list != [] and prdcts != []
		prdcts.each do |p|
			val = products_list[("check_#{p.id}").to_sym].to_i
			amount = products_list[("amount_#{p.id}").to_sym].to_i
			cLink = p.unit_product_links.where(:unit_id => self.id).first
			if val == 0
				cLink.destroy if cLink != nil
			elsif val == 1
				if cLink == nil
					p.unit_product_links.create(:unit_id => self.id)
				else
					cLink.update_attribute(:amount, amount) if cLink.amount != amount
				end
			end
		end
	end
  end
  
  def f_name
	if full_name != ''
		full_name
	else
		name
	end
  end
  
  def components
	c_links = self.unit_component_links.select(:component_id)
	if c_links != []
		return c_links
	else
		return []
	end
  end
end
