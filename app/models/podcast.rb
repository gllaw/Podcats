class Podcast < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :replies, through: :comments #don't need this bc you never want replies without assoc comment.
  
  validates :show, :link, presence: true

end
