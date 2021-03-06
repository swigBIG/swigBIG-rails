class User < ActiveRecord::Base
  include Amistad::FriendModel

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable #, :confirmable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessor :authenticity_token
  attr_accessible :email, :password, :password_confirmation, :remember_me, :terms, :bird_date, :slug,
    :avatar, :name, :address, :zip_code, :phone_number, :city, :state, :last_seen, :access_token,
    :fb_id, :lock_status, :lock_fb_post, :fb_post_swig

  extend  FriendlyId

  friendly_id :name , use: :slugged

  with_options dependent: :destroy do |user|
    user.has_many :points
    user.has_many :swigers
    user.has_many :winners
    user.has_many :popularity_inviters
    user.has_many :popularity_guesses
  end

  acts_as_messageable required: [:topic, :body, :received_messageable_id ]

  mount_uploader :avatar, ImageUploader

  validates :terms, :acceptance => true

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    img = access_token.info.image
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
      user
    else # Create a user with a stub password.
      a = self.create!(:email => data.email, :password => Devise.friendly_token[0,20], name: data.name)
      return a
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
