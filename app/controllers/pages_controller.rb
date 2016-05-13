class PagesController < ApplicationController
  def index
		@title = "Главная"
    @products = Product.where(visibility: 'visible', visible_in_slider: 'yes')
  end

  def contacts
    @title = @header = "Контакты"
  end

  def about_us
    @title = @header = "О нас"
  end
end
