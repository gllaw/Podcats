class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy

  has_secure_password
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, :user_name, presence: true, length: {minimum: 2}
  validates :age, presence: true, numericality: { only_float: true }
  validates :email, presence: true, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: {minimum: 8}

  before_save do 
  	self.email.downcase!
  	first_name.capitalize!
  	last_name.capitalize!
  end
  
end
