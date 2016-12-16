class Comment < ActiveRecord::Base
  belongs_to :podcast
  belongs_to :user
  has_many :replies, dependent: :destroy
  # has_many :repliers, through: :replies, source: :user

  validates :podcast_id, :user_id, :comment, presence: true

# join comments to podcasts + find all comments by podcast id, desc.
  def self.episode_comments pod_id
    self.joins(:user).select(:comment, :podcast_id, "users.id as user_id", "users.user_name as commenter", "comments.id as comment_id").where("comments.podcast_id = #{pod_id}").order("comment_id desc").limit(25)
  end

  # def self.comment_replies 						#future feature to add
  #   self.includes(:user, :replies).select(:reply, "user.user_name as replier", ).limit(5)
  # end


end
