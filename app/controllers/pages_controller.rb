class PagesController < ApplicationController
  def index
		@title = "Главная"
    
  end

  def contacts
    @title = @header = "Контакты"
  end

  def about_us
    @title = @header = "О нас"
  end
end
