module PriceListHelper
  
  def price_list_product_part(p)
    "
    <div class = 'nobreak'>
         <table>
             <tr>
                 <td colspan = '2'>
                     <h2 style = 'padding-left:10px;'>
                         #{p.s_name}
                     </h2>
                     #{"<h3 style = 'padding-left:10px;'>#{p.name}</h3>" if p.name != p.s_name}
                     <hr noshade size = 1/>
                 </td>
             </tr>
             <tr>
                 <td style = 'width: 40%;' align = 'center'>
                     <img src = 'file:///#{Rails.root}/public#{p.photo.link.thumb.url}'>
                 </td>

                 <td align = 'center' valign = 'middle' style = 'background-color:#eae3d7;'>
                     <p class = 'cost-field'>Цена: <b>#{p.rur_cost(true).html_safe}</b></p>
                     <p>НДС не начисляется в связи<br />с применением УСН</p>
                 </td>
             </tr>
             <tr>
                 <td colspan = '2'>
                     <div class = 'nobreak'>
                     <table class = 'content-field'>
                         <tr>
                             <td>
                                 <h3>Описание</h3>
                                 #{p.description.html_safe}
                             </td>
                         </tr>
                         #{"<tr><td><div class = 'nobreak'><h3>Технические характеристики </h3><table>#{p.table_rows.html_safe}</table></div></td></tr>" if !p.table_rows.blank?}
                     </table>
                     </div>
                 </td>
             </tr>
         </table>
   </div>
    ".html_safe
  end
  
  
  def make_new_price
    copy_old_price_to_archive
    @title = @header = "Актуальные цены на продукцию"
    @products = Product.where(visibility: 'visible', product_id: nil).order("order_number ASC")
    pdf = render_to_string(
                            pdf: "price_list", 
                            template: "pdf_layouts/price_list.pdf", 
                            encoding: "UTF-8",
                            margin:  {   top:               15,                     # default 10 (mm)
                                         bottom:            15,
                                         left:              0,
                                         right:             0},
                            footer:  { html: {template:'pdf_layouts/footer.pdf'}},
                            header:  { html: {template:'pdf_layouts/header.pdf'}, spacing: 7}
                          )
    save_path = Rails.root.join(price_list_storage_url,'price_list.pdf')
    File.open(save_path, 'wb') do |file|
       file << pdf.encode("ASCII-8BIT").force_encoding("utf-8")
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
