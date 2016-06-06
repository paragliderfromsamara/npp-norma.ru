module ProductsHelper
	

	def productCategoryButtons
		product = Product.new
		val = [{:title => 'Вся продукция', :link => '?', :name => 'Все'}]
		product.categories.each do |cat|
			val[val.length] = {:title => cat[:m_name], :link => "?c=#{cat[:id]}", :name => cat[:tab_name]}
		end
		return val
	end

	def productCategoryMenu
		product = Product.new
		cur = (params[:c]).to_i
		v = '<li class="menu-text"><i class = "fi-database"></i> Категории</li>'#admin? ? "<li id = 'first'><a href='#{new_product_path}'><i class='fi-plus'></i> <span>Добавить</span></a>" : ''
		productCategoryButtons.each do |but|
      id = productCategoryButtons.first == but and !admin? ? 'id = "first"' : '' 

			v += "<li #{id} #{'class = "active"' if product.categoryById(cur)[:tab_name] == but[:name]}><a href='#{but[:link]}'>#{'<i class = "fi-arrow-right fi-size-m"></i>' if product.categoryById(cur)[:tab_name] == but[:name]}#{but[:name]}</a></li>" 
		end
		return ("<ul class=\"menu vertical\" >#{v}</ul>").html_safe
	end
	
	def mini_photo_block(entity, block_params)
				"<div style = 'width: #{block_params[:width].to_s}px; height: #{block_params[:height].to_s}px; margin-top: #{margin_top(block_params[:x_pos], block_params[:y_pos], block_params[:height]).to_s}px; margin-left: #{margin_left(block_params[:x_pos], block_params[:y_pos], block_params[:height]).to_s}px'>
					#{image_tag entity.link.thumb, :width => block_params[:width].to_s}
				</div>"
	end
	
  def file_type_ru(file_type)
	if file_type == "firmware"
		"Прошивка"
	elsif file_type == "document"
		"Текстовая документация"
	elsif file_type == "software"
		"Программное обеспечение для ПК"
	end
  end
  
  def attachments(file_type)
	files = AttachmentFile.where(product_id: @product.id, file_type: file_type)
	text = ""
	if files != []
		text += "
					<b>#{file_type_ru(file_type)}:</b><br />
				"
		files.each do |file|
			text += "#{link_to file.name, file.link} | #{link_to('Удалить', "/destroy_file/#{file.id}", :confirm => ("Вы уверены, что хотите удалить #{file.name}?"))}<br /> "
		end
		return text.html_safe
	else
		return ""
	end
  end
  
  def show_parent_device(product)
	if product.product_id != nil and product.product_id != ""
		head = "<b>Данное изделие является опцией к #{link_to product.product.name, product.product, :target => "_blank"} </b>#{image_tag(product.product.photo.link.mini, :valign => 'middle') if product.product.photo != nil}"
		
		return ("<p>#{head}<br /></p>").html_safe
	else
		return ""
	end
  end
  
  def comments_list
	content = "<p>По данному изделию нет ни одного отзыва</p>"
	if @comments != []
		content = ""
		rows = ""
		@comments.each do |comment|
			rows += "<tr class = 'item_row'><td width='30px'>#{image_tag comment.link.mini, :valign => 'middle'}</td><td>#{link_to(("#{comment.from}").html_safe, comment, :class => 'item_links', :title => 'Перейти к отзыву')}</td></tr>"
		end
		content += "<div class = 'item_field'><div class = 'table_parent'><table style = 'width: 100%;'>#{rows}</table></div></div>"
	end
	return content.html_safe
  end
  
  def productBlocksArray(products)
	val = ""
	if !products.blank? 
		products.each do |product| 
      val += product_row_block({name: product.s_name, link: product_path(product), photo: product.alter_photo_thumb, description: product.note, photo_cols_num: 3}) 
    end
	end 
	return "#{val}"
  end
  
  def productsByCategories
	prd = Product.new
	categories = prd.categories
	val = ''
  i = 0
	categories.each do |cat|
    i += 1
		products = Product.where(category_id: [0, nil]) if cat[:id] == 0
		products = Product.where(category_id: cat[:id]) if cat[:id] != 0
		if products != []
			val += "
                    #{productBlocksArray(products)}
             "
		end
	end
	return val.html_safe
  end
  
  def getMenuProductsList
    v = []
  	products = Product.where(visibility: 'visible') if user_type != 'admin'
  	products = Product.all if user_type == 'admin'
    if products != []
      products.each do |p|
        v[v.length] = {name: p.s_name, link: product_path(p)}
      end 
    end
    return v
  end
  def getCurViewMode
    if !session[:v_mode].blank? && params[:v_mode].blank?
      @v_mode = session[:v_mode]
    elsif params[:v_mode] == 'th' ||  params[:v_mode] == 'lst'
      @v_mode = session[:v_mode] = params[:v_mode]
    else
      @v_mode = session[:v_mode] = 'th' 
    end
  end
end
