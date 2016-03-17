class AttachmentFile < ActiveRecord::Base
  attr_accessible :link, :product_id, :file_type, :name
  belongs_to :product
  
  def file_type_ru
	if file_type == "firmware"
		"Прошивка"
	elsif file_type == "document"
		"Текстовая документация"
	elsif file_type == "software"
		"Программное обеспечение для ПК"
	end
  end
  
  def current_type
	if file_type == "firmware"
		["firmware", "Прошивка"]
	elsif file_type == "document"
		["document", "Текстовая документация"]
	elsif file_type == "software"
		["software", "Программное обеспечение для ПК"]
	elsif file_type == "price_list"
		["price_list", "Рекламный буклет"]
	end
  end
  
  def file_types
	[["firmware", "Прошивка"], ["software", "Программное обеспечение для ПК"], ["document", "Текстовая документация"]]
  end
end
