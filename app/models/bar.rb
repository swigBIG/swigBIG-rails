class Bar < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:omniauthable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address,
    :zip_code, :phone_number, :city, :state, :country, :latitude, :longitude, :logo, :slug,
    :status, :qrcode, :plan_id, :service_uid, :terms, :bar_background, :sports_team
  # attr_accessible :title, :body

  mount_uploader :logo, ImageUploader
  mount_uploader :bar_background, ImageUploader

  #  acts_as_messageable required: [:topic, :body, :received_messageable_id ]
  
  validates :terms, :acceptance => true

  with_options dependent: :destroy do
    has_many :swigs
    has_many :swigers
    has_many :products
    has_many :points
    #    has_many :rewards
    has_many :winners
    has_one :loyalty
    has_one :popularity
  end

#  accepts_nested_attributes_for :, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  before_update  :set_lat_lng

  extend  FriendlyId

  friendly_id :name , use: :slugged

#  def to_param
#    "#{id} #{name}".parameterize
#  end

  #  geocoded_by :latitude  => :latitude, :longitude => :longitude

  def full_address
    "#{self.address}, #{self.city}, #{self.state}, United states"
    #    "#{self.address}, #{self.city}, #{self.state}, Indonesia"
  end

  def set_lat_lng
    begin
      coordinates = Geocoder.coordinates("#{self.address}, #{self.city}, United states")
      self.latitude = coordinates.first
      self.longitude = coordinates.last
    rescue
      self.latitude = nil
      self.longitude = nil
      logger.error "failed to get coordinates"
    end
  end
  
end
