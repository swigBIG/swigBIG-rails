class Bar < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address,
    :zip_code, :phone_number, :city, :state, :country, :latitude, :longitude, :logo, :slug,
    :status, :qrcode, :plan_id, :service_uid
  # attr_accessible :title, :body

  mount_uploader :logo, ImageUploader

  before_update  :set_lat_lng

  extend  FriendlyId

  friendly_id :name, use: [:slugged, :history]

  #  geocoded_by :latitude  => :latitude, :longitude => :longitude

  def full_address
    "#{self.address}, #{self.city}, #{self.state}, United states"
  end

  def set_lat_lng
    begin
      coordinates = Geocoder.coordinates(full_address)
      self.latitude = coordinates.first
      self.longitude = coordinates.last
    rescue
      self.latitude = nil
      self.longitude = nil
      logger.error "failed to get coordinates"
    end
  end
  
end
