class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_login
  	redirect_to :root if session[:user_id] == nil 
  end

  def require_correct_user
  	user = User.find(params[:id]) if params[:id]
  	if current_user != user
  	  flash[:error] = "You do not have permission."
      redirect_to :back
    end
  end

  def current_admin
    Admin.find(session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  def require_admin_login
    redirect_to :root if session[:admin_id] == nil
  end
  # def require_correct_admin
  # 	admin = Admin.find(params[:id])
  # 	flash[:error] = "Why are you trying to fleece other admins?"
  #   redirect_to "/admins" if current_admin != admin
  # end

end
