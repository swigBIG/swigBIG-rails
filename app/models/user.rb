class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :terms, :bird_date,
    :avatar, :name, :address, :zip_code, :phone_number, :city, :state, :last_seen

  # attr_accessible :title, :body
  mount_uploader :avatar, ImageUploader

  validates :terms, :acceptance => true
end
