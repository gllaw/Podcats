class UsersController < ApplicationController
	before_action :require_login, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  def new								                 #load reg page
  end

  def create							               #register
    user = User.new(user_params)
  	if user.save
  	  session[:user_id] = user.id
  	  redirect_to "/podcasts/index"
  	else
  	  flash[:errors] = user.errors.full_messages
      redirect_to :back
    end
  end

  # def show								#user profile page, which we aren't doing.
  # 	@user = User.find(params[:id])
  # end

  def edit 							                #render user page 
  	@user = User.find(session[:user_id])
  end

  def update                            #update user info
  	user = User.find(params[:id])
    user.update(user_params)
    if (user.save)
      flash[:edited] = "Successfully updated user info."
      redirect_to "/podcasts/index"
    else
      flash[:errors] = user.errors.full_messages
      redirect_to :back
    end
  end

  def destroy							            #delete account
  	User.find(params[:id]).destroy
  	reset_session
  	redirect_to :root
  end

  private
  def user_params
  	params.require(:user).permit(:user_name, :email, :first_name, :last_name, :age, :password, :password_confirmation)
  end
end
