class Bar < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:omniauthable,
  :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :address,
    :zip_code, :phone_number, :city, :state, :country, :latitude, :longitude, :logo, :slug,
    :status, :qrcode, :plan_id, :service_uid, :terms, :bar_background, :sports_team, :website_link,
    :facebook_link, :twitter_link, :google_plus_link, :bar_phone, :bar_description, :bar_hour,
    :bar_hours_attributes, :full_address
  # attr_accessible :title, :body

  mount_uploader :logo, ImageUploader
  mount_uploader :bar_background, ImageUploader

  #  acts_as_messageable required: [:topic, :body, :received_messageable_id ]
  
  validates :terms, :acceptance => true
  validates :address, :zip_code, :city, :sports_team, :presence => true, :on => :update
  validates_format_of :zip_code, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234", :on => :update
  
  with_options dependent: :destroy do
    has_many :bar_hours
    has_many :swigs
    has_many :swigers
    has_many :products
    has_many :points
    has_many :popularity_inviters
    #    has_many :rewards
    has_many :winners
    has_one :loyalty
    has_one :popularity
  end

  accepts_nested_attributes_for :bar_hours, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :swigs, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  #  before_update  :set_lat_lng
  geocoded_by :full_address

  after_validation :geocode, :if => :address_changed?

  before_save :update_swig_location, :set_full_address

  after_create :create_hour

  extend  FriendlyId

  friendly_id :name , use: :slugged

  #    geocoded_by :latitude  => :latitude, :longitude => :longitude

  def update_swig_location
    self.swigs.each do |swig|
      swig.update_attributes(address: self.address, latitude: self.latitude, longitude: self.longitude, city: self.city)
    end
  end

  def create_hour
    self.bar_hours.create(day: "Monday")
    self.bar_hours.create(day: "Tuesday")
    self.bar_hours.create(day: "Wednesday")
    self.bar_hours.create(day: "Thursday")
    self.bar_hours.create(day: "Friday")
    self.bar_hours.create(day: "Saturday")
    self.bar_hours.create(day: "Sunday")
  end

  def set_full_address
    self.full_address = "#{self.address},#{self.city},#{self.zip_code}, United States"
  end
  
end
