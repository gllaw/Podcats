class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  validates :reply, presence: true

  # def self.comment_replies com_id
  #   self.joins(:comment).includes(:user).select(:reply, "replies.user_id as replier").where("replies.comment_id = #{com_id}").limit(5)
  # end
end


