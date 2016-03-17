class SessionsController < ApplicationController
  def new
	  @title = @header = "Вход на сайт"
  end

  def create
    user = User.authenticate(params[:session][:name],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Неверное имя пользователя или пароль"
      @title = "Вход"
      render 'new'
    else
      sign_in user
	  redirect_to "/index"
    end
  end

  def destroy
	sign_out
    redirect_to root_path
  end
end
