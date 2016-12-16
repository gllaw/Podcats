class CommentsController < ApplicationController
  before_action :require_login
  # before_action :require_correct_user, only: [:destroy]
  
  def create						#adding new comment to table.
  	comment = Comment.new(comment: params[:comment], user_id: session[:user_id], podcast_id: params[:podcast_id])
  	if comment.save
  	  redirect_to :back
    else
  	  flash[:error] = "Comment can not be blank."
  	  redirect_to :back
  	end
  end

  def comments_partial 					#render partial in podcast show
  	@podcast_id = params[:id]
    @comments = Comment.episode_comments(params[:id])
  end

  def destroy 			  #delete comment link only shows if it's yours.
  	Comment.find(params[:id]).destroy
  	redirect_to :back
  end
end
