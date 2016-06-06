class PagesController < ApplicationController
  def index
		@title = "Главная"
    @products = Product.where(visibility: 'visible', visible_in_slider: 'yes')
  end

  def contacts
    @title = @header = "Контакты"
  end

  def price_list
    @title = @header = "Актуальные цены на продукцию"
    @products = Product.where(visibility: 'visible')
    respond_to do |format|
      format.html 
      format.json { render :json => @products }
      format.pdf do 
        render pdf: "price_list"   # Excluding ".pdf" extension.
      end
    end
  end
  
  def about_us
    @title = @header = "О нас"
  end
end
