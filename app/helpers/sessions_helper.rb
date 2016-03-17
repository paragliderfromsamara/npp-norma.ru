module SessionsHelper
	
  def sign_in(user)
  cookies.permanent.signed[:remember_token] = [user.id, user.salt]
  self.current_user = user
  end
  
  def current_user=(user)
  @current_user = user
  
  
  end
   
  def current_user
	@current_user ||= user_from_remember_token
	
  end
  def user_type
	if current_user != nil
		if @current_user.user_type == "Администратор"  
			user_type = "admin"
		elsif @current_user.user_group_id == "Пользователь" 
			user_type = "user"
		end
	else
		user_type = "guest"
	end
  end
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
	
	def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
    end
	
    def signed_in?
    !current_user.nil?
    end
	
	def admin?
		user_type == 'admin'
	end
	
	def user?
		user_type == 'user'
	end
	
end
