class User < ActiveRecord::Base
  include Amistad::FriendModel

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable #, :confirmable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :terms, :bird_date,
    :avatar, :name, :address, :zip_code, :phone_number, :city, :state, :last_seen

  # attr_accessible :title, :body
  with_options dependent: :destroy do
    has_many :points
    has_many :swigers
    has_many :winners
  end


  mount_uploader :avatar, ImageUploader

  validates :terms, :acceptance => true

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    img = access_token.info.image
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
      user
    else # Create a user with a stub password.
      self.create!(:email => data.email, :password => Devise.friendly_token[0,20], avatar: img)
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
end
