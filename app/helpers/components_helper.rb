module ComponentsHelper

def show_binded_products
	cLinks = @component.component_links  
	if cLinks != []
		head = "<div class = 'list_items_header'><b>Где применяется</b></div>"
		links = ""
		cLinks.each do |l|
			links += "<tr class = 'item_row' ><td valign = 'middle' align = 'left' height = '40px' width = '40px'> #{image_tag(l.product.photo.link.mini) if l.product.photo != nil}</td><td valign = 'middle' align = 'left'>#{link_to(l.product.s_name, l.product, :target => "_blank", :class => 'item_links', :title => "Перейти к #{l.product.name}")}</td></tr>"
		end
		return ("#{head}<div class = 'item_field'><div class = 'table_parent'><table style = 'width: 100%;'>#{links}</table></div></div>").html_safe
	else
		return ""
	end
end

def product_show_components_table
	v = ''
	@component_types.each do |t|
		components = Component.where(:component_type_id => t, :id => @product.component_links.select(:component_id))
		v += "<tr><th align = 'left' colspan = '2'><p>#{t.name}</p></th><th id = 'linkRow'></th></tr>"
		components.each do |c|
			v += "<tr><td id = 'cPhoto' valign = 'middle'><a href = '#{ c.alter_photo }' data-lightbox='roadtrip' title = '#{ c.name }'>#{ image_tag c.alter_photo_mini, :height => '30px'  }</a></td><td valign = 'middle' align = 'left'><p>#{c.name}</p></td><td valign = 'middle' id = 'linkRow'>#{link_to 'подробнее', c}</td></tr>"
		end
	end
	return ("<table id = 'cTable'>#{v}</table>").html_safe
end

def migrateComponents #967
	@textBig = IO.read(Rails.root.join('public/warehouseData', 'components'))
	errors = ''
	@txt = ""
	i = 0
	begin 
		i += 1
		directory = "public/warehouseData"
		FileUtils.mkdir_p(directory) unless File.exists?(directory)
		File.open(Rails.root.join(directory, 'componentErrorsLog'), 'w') do |file|
			file.write("component_#{i}")
		end
		text = extract_from_tag(@textBig, "component_#{i.to_s}", true)
		component_type_name = extract_from_tag(text, 'component_type_name', false)
		spec_component_type_name = extract_from_tag(text, 'spec_component_type_name', false)
		component_name = extract_from_tag(text, 'component_name', false)
		component_designation = extract_from_tag(text, 'component_designation', false)
		quantitative_measure_id = extract_from_tag(text, 'quantitative_measure_id', false)
		@txt += "component_#{i}<br />"
		@txt += "ComponentTypeName: #{component_type_name} <br />"
		@txt += "SpecComponentTypeName: #{spec_component_type_name} <br />"
		@txt += "componentName: #{component_name} <br />"
		@txt += "componentDesignation: #{component_designation} <br />"
		@txt += "quantitativeMeasureId: #{quantitative_measure_id} <br />"
		@txt += "text: #{text} <br /><br />"
		component_type_name = 'Не определено' if component_type_name == nil 
		
		component_type = ComponentType.find_by_name(component_type_name)
		spec_component_type = SpecComponentType.find_by_name(spec_component_type_name)
		if component_type == nil
			component_type = ComponentType.create(:name => component_type_name)
		end
		if spec_component_type == nil
			spec_component_type = SpecComponentType.create(:name => spec_component_type_name)
		end
		component = Component.create(
														:name => component_name, 
														:designation => component_designation,
														:quantitative_measure_id => quantitative_measure_id,
														:component_type_id => component_type.id,
														:spec_component_type_id => spec_component_type.id
													)
	end until(i == 769)
	if errors != ''
		directory = "public/warehouseData"
		FileUtils.mkdir_p(directory) unless File.exists?(directory)
		File.open(Rails.root.join(directory, 'componentErrorsLog'), 'w') do |file|
			file.write(errors)
		end
	end
end

end
