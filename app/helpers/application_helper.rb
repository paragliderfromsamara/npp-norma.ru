module ApplicationHelper
  def my_title
    (@title == nil)? "Норма - Научно-Производственное Предприятие" : @title
  end
  def my_header
    if @header != nil
      return "<div class='row tb-pad-s'><div class='small-12 columns'><h1>#{@header}</h1></div></div>"
    else
      return ""
    end
  end
  def meta_content
    default = "сопротивление изоляции, параметры влияния, рабочее затухание, рабочая емкость, сопротивление жил, сопротивление токопроводящих жил, высоковольтные испытания, система контроля электрический параметров кабелей связи, КИП, контрольно-измерительные приборы"
    @meta_tags.blank? ? default : @meta_tags
  end
  def mainMenuItems
    [
      {
        name: "Главная",
        link: "/"
      },
      {
        name: "Продукция",
        #link: products_path,
        items: getMenuProductsList
      },
      {
        name: "Контакты",
        link: "/contacts"
      },
      {
        name: "<i class = 'fi-price-tag'></i> Прайс лист",
        link: "/price_list",
        rel: "no-follow",
        target:'_blank' 
      }
    ]
  end
  def drawMenu
    h = ""
    mainMenuItems.each do |i|
      if !i[:items].nil?
        h += makeMenuDropItems(i)
      else
        h += "<li #{"class = 'active'" if current_page?(i[:link])}><a #{i[:rel].blank? ? "" : "rel='#{i[:rel]}'" } #{i[:target].blank? ? "" : "target = '#{i[:target]}'"} href='#{i[:link]}'>#{i[:name]}</a></li>"
      end
    end
    return h.html_safe
  end
  def makeMenuDropItems(i)
    v = ""
    i[:items].each do |s|
      v += "<li #{"class = \"active\"" if current_page?(s[:link])}><a href=\"#{s[:link]}\">#{s[:name]}</a></li>"
    end
    v = "<li>
            <a href=\"#{i[:link]}\">#{i[:name]}</a>
            <ul class='menu'>
              #{v}
            </ul>
        </li>"
    return v
  end
  
  def update_last_view_list(type, id)
    #session[:visited_device] = []
    list = session[:visited_device]
    add_val = [type, id]
    if list.blank?
      list = Array.new
      list[0] =  add_val
    else
      #list.unshift(add_val)
      list = (list.reverse + [add_val]).reverse
      list = list.uniq
      list.pop if list.size > 6
    end
    session[:visited_device] = list
    return show_last_visited(list)
  end
  def show_last_visited(list)
    #list = session[:visited_device]
    v = ''
    if !list.blank?
      list.each do |l|
        if l[0] == "product"
          #v += "#{l}<br />"
          if !@product.nil?
            next if @product.id == l[1]
          end
          product = Product.find_by(id: l[1])
          if !product.nil?
            pHash = {
                      name: product.s_name,
                      link: product_path(product),
                      photo: product.alter_photo_thumb,
                      description: product.note,
                      photo_cols_num: 5
                    }
            v += product_row_block(pHash, nil, 75)
          end  
        elsif l[0] == "component"
          if !@component.nil?
            next if @component.id == l[1]
          end
          component = Component.find_by(id: l[1])
          if !component.nil?
            pHash = {
                      name: component.name,
                      link: component_path(component),
                      photo: component.alter_photo_thumb,
                      description: component.description,
                      photo_cols_num: 5
                    }
            v += product_row_block(pHash, nil, 75)
          end  
        end
        
      end
    end
    return v
  end
  
  def product_row_block(pHash, nTrunc=nil, dTrunc=nil) # pHash = {:name, :link, :photo, :description, :photo_cols_num}
    name = (pHash[:name].blank?) ? "Имя не указано" : pHash[:name]
    link = (pHash[:link].blank?) ? "/404" : pHash[:link]
    photo = (pHash[:photo].blank?) ? "/no_photo" : pHash[:photo]
    desc = (pHash[:description].blank?) ? "Без описания" : pHash[:description]
    phColsNum = pHash[:photo_cols_num].blank? ? 4 : pHash[:photo_cols_num]
    descColsNum = 12 - phColsNum 
    
    v = "<div class = 'callout medium'>
          <h2>#{nTrunc.nil? ? name : truncate(name, length: nTrunc)}</h2>
        <div class='row'>
            <div class = 'small-12 medium-#{phColsNum} columns'>
              <a class = 'float-left' href = '#{link}'>#{image_tag photo, class: 'thumbnail'}</a>
            </div>
            <div class = 'small-12 medium-#{descColsNum} columns end'>
              <p>#{dTrunc.nil? ? desc : truncate(desc, length: dTrunc)}</p>
              <p><a href = '#{link}'><i class='fi-arrow-right'></i> перейти</a></p>
            </div>
        </div>
      </div>"
      return v
  end
  
	def collection_list(options, name, current_value)
		output = ""
		options_str = ""
		options_str += "<option value = '#{current_value[0]}'>#{current_value[1]}</option>" if current_value != []
		options.each do |option|
			options_str += "<option value = '#{option[0]}'>#{option[1]}</option>" if current_value[0] != option[0]
		end
		select_tg = "<select name = '#{name}'>#{options_str}</select>"
		return select_tg.html_safe
	end
  
	def extract_from_tag(text, tag_name, includeSlashN)	
		regex = /\[#{tag_name}\]((.|\n)+)\[\/#{tag_name}\]/ if includeSlashN = true
		regex = /\[#{tag_name}\](.+)\[\/#{tag_name}\]/ if includeSlashN = false
		content = 'Не определено'
		text.gsub(regex) do |match|
			if $1 != nil and $1 != ''
				content = $1
			end
		end
		return content
	end
  
  def make_new_price
    copy_old_price_to_archive
    @title = @header = "Актуальные цены на продукцию"
    @products = Product.where(visibility: 'visible')
    pdf = render_to_string pdf: "price_list", template: "pages/price_list.pdf", encoding: "UTF-8"
    save_path = Rails.root.join(price_list_storage_url,'price_list.pdf')
    File.open(save_path, 'wb') do |file|
       file << pdf
    end
  end
  
  def price_list_link(short=false) #директория актуального прайс листа
    short ? "/#{price_list_storage_url(true)}/price_list.pdf" : Rails.root.join(price_list_storage_url,'price_list.pdf')
  end
  
  private 
  
  def doesActualPriceExist?
    doesDirExist?(price_list_link)
  end 
  
  def copy_old_price_to_archive
    if doesDirExist?(price_list_link)
      d = price_archive_url
      old_price = File.new(price_list_link)
      save_path = Rails.root.join(d, old_price_name(old_price.ctime))
      File.open(save_path, 'wb') do |file|
        file << old_price.read
      end
    end
  end
  
  def doesDirExist?(d)
    File.exists?(d)
  end

  def price_list_storage_url(short=false)#место хранения актуального прайса
    d = short ? "prices/actual_price" : "public/prices/actual_price"
    FileUtils.mkdir_p("public/prices/actual_price") unless File.exists?("public/prices/actual_price")
    return d
  end
  
  def price_archive_url(short=false) #архив прайс листов
    d = short ? "prices/archive" : "public/prices/archive"
    FileUtils.mkdir_p("public/prices/archive") unless File.exists?("public/prices/archive")
    return d
  end
  
  def old_price_name(date) # формирует название архивного прайслиста
    date.strftime "прайс_от_%m-%d-%Y.pdf"
  end
end
