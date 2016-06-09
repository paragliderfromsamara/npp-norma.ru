class PagesController < ApplicationController
  include PriceListHelper
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
    end
  end
  
  def about_us
    @title = @header = "О нас"
  end
end
