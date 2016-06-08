class PagesController < ApplicationController

  def index
		@title = "Главная"
    @products = Product.where(visibility: 'visible', visible_in_slider: 'yes')
  end

  def contacts
    @title = @header = "Контакты"
  end

  def price_list
    make_new_price if params[:make_price] == 'true' || !doesActualPriceExist?
    respond_to do |format|
      format.html {redirect_to price_list_link(true)}
    #  format.json { render :json => @products }

    #  render pdf: redirect_to "#{price_list_link(true)}"  # Excluding ".pdf" extension.
    #           disposition:                    'inline',                 # default 'inline'
     # show_as_html:                   params.key?('debug')         # allow debugging based on url param
    end

    #File.new(Rails.root.join(price_list_storage_url,'price_list.pdf')).ctime.strftime("%Y-%m-%d_%H:%M") if doesDirExist?(Rails.root.join(price_list_storage_url,'price_list.pdf'))
    #redirect_to "/prices/price_list.pdf"
  end
  
  def about_us
    @title = @header = "О нас"
  end
end
