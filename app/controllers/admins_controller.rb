class AdminsController < ApplicationController
  before_action :require_admin_login, only: [:dash]
  
  def index
  end

  def login
    if admin = Admin.find_by_email(params[:email])
      if (params[:password] == admin[:password])
        session[:admin_id] = admin.id
        redirect_to "/admins/dash"
      else
        flash[:error] = "Invalid."
        redirect_to :back
      end
    else
        flash[:error] = "Invalid"
        redirect_to :back
    end
  end

  def dash
    @podcast = Podcast.all
  end

  def create
    p = Podcast.new(show: params[:show], episode: params[:episode], link: params[:link], description: params[:description], genre: params[:genre], type_id: params[:type_id].to_i)
    if p.save
      flash[:success] = "Good work, Admin!"
      redirect_to "/admins/dash"
    else
      flash[:errors] = p.errors.full_messages
      redirect_to :back
    end
  end

  def editors_choice
    @admin = Admin.find(session[:admin_id])
  end

end
