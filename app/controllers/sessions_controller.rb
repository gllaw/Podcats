class SessionsController < ApplicationController

  def index 					                   #load login page
  end

  def create					                   #log in
  	user = User.find_by_email(user_params[:email])
    if (user && user.authenticate(user_params[:password]))
      session[:user_id] = user.id
      redirect_to "/podcasts/index"
    else
      flash[:error] = "Invalid. Are you registered?"
      redirect_to :back
    end
  end

  def destroy				                     #log out
  	reset_session
  	redirect_to :root
  end

  private
  def user_params
  	params.require(:user).permit(:email, :password)
  end

end
