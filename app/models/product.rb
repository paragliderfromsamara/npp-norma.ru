class Product < ActiveRecord::Base
  attr_accessible :cost, :description, :in_warehouse, :name, :product_id, :short_name, :notice, :visibility, :uploaded_photos, :photo_id, :visible_in_slider, :order_number, :note, :category_id
  has_many :photos, :dependent => :delete_all
  has_many :attachment_files, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_many :component_links, :dependent => :delete_all
  has_many :unit_product_links, :dependent => :delete_all
  has_many :planner_devices, :dependent => :delete_all
  belongs_to :photo
  belongs_to :product
  
  def units
	Unit.where(:id => self.unit_product_links.select(:unit_id))
  end
  
  def unit(u_id)
	unit_product_link = UnitProductLink.find_by_unit_id_and_product_id(u_id, self.id)
	if unit_product_link != nil
		return unit_product_link.unit
	else
		return nil
	end
  end
  
  def unused_units
	allUnits = Unit.order('name ASC')
	if self.units != []
		allUnits -= self.units
	end
	return allUnits
  end
  
  def categories
	[	
		{:id => 2, :name => 'Измерительная сиcтема', :m_name => 'Измерительные системы', :tab_name => 'Системы'},
		{:id => 1, :name => 'Измерительный прибор', :m_name => 'Измерительные приборы', :tab_name => 'Приборы'},	
		{:id => 3, :name => 'Измерительный комплекс', :m_name => 'Измерительные комплексы', :tab_name => 'Комплексы'},
		{:id => 4, :name => 'Высоковольтная установка', :m_name => 'Высоковольтные установки', :tab_name => 'Установки'},
		{:id => 5, :name => 'Дополнительная опция', :m_name => 'Дополнительные опции', :tab_name => 'Опции'}		
		#{:id => 100, :name => 'Остальное', :m_name => 'Остальное', :tab_name => 'Остальное'}
	]
  end
  
  def component_types
	if self.component_links == []
		return []
	else
		return ComponentType.where(:id => Component.where(:id => self.component_links.select(:component_id)).select(:component_type_id)).order('name ASC')
		
	end
  end
  
  def category
	val = {}
	if self.category_id == nil
		val = categories.first
	else
		categories.each do |cat|
			val = cat if cat[:id] == self.category_id  
		end
		val = categories.first if val == {}
	end
	return val
  end
  
  def categoryById(cat_id)
	val = {}
	categories.each do |cat|
		val = cat if cat[:id] == cat_id 
	end	
  val = {:tab_name => 'Все', :m_name => 'Вся производимая продукция', id: categories.map{|c| c[:id]}} if val.blank?
	return val
  end
  
  def uploaded_photos=(attrs)
	attrs.each {|attr| self.photos.build(:link => attr)}
  end
  
  def visibility_statuses
	[["Показывать в каталоге продукции", "visible"], ["Не показывать в каталоге продукции", "invisible"]]
  end
  
  def visibility_status(status)
	if status == 'visible'
		"Показывать в каталоге продукции"
	elsif status == 'invisible'
		"Не показывать в каталоге продукции"
	end
  end
  
  def s_name
    short_name.blank? ? name : short_name
  end
  
  def options
	Product.where(:product_id => id)
  end
  
  def rur_cost
    if cost == 0.0
      'Цена не указана'
    else
      c = cost.to_i.to_s.reverse
      v = ''
      i = 0
      c.chars do |c|
        i += 1
        v += i==3 ? "#{c} " : c
        i = 0 if i == 3
      end
      return "<span class = 'stat'>#{v.strip.reverse}</span> рублей"
    end
  end

  def nds   
  	"<span data-tooltip aria-haspopup='true' class='has-tip right' data-disable-hover='false' tabindex='1' title='НДС не начисляется в связи с применением упрощённой системы налогообложения'>
      НДС не начисляется
    </span>"
  end
  
end

