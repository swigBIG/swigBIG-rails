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
    :bar_hours_attributes, :full_address, :sports_team_list, :lock_status#, :swigs_attributes
  # attr_accessible :title, :body
  validates :terms, :acceptance => true
  validates :address, :zip_code, :city, :presence => true, :on => :update
#  validates :zip_code, format: {:with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234"}, :on => :update

  mount_uploader :logo, ImageUploader
  mount_uploader :bar_background, ImageUploader

  before_update  :set_full_address, :set_coordinates, :set_http_website

  geocoded_by :address
  after_validation :geocode

  after_update :update_swig_location

  acts_as_taggable_on :sports_teams

  #  geocoded_by :full_address, :latitude  => :latitude, :longitude => :longitude

  #  after_validation :geocode, :if => :full_address_changed?

  after_create :create_hour

  acts_as_messageable required: [:topic, :body, :received_messageable_id]
  
  
  with_options dependent: :destroy do |bar|
    bar.has_many :bar_hours
    bar.has_many :big_swig_lists
    bar.has_many :gifts
    bar.has_many :swigs
    bar.has_many :swigers
    bar.has_many :products
    bar.has_many :points
    bar.has_many :popularity_inviters
    bar.has_many :winner_rewards
    bar.has_many :winners
    bar.has_one :loyalty
    bar.has_one :popularity
  end

  accepts_nested_attributes_for :bar_hours#, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
#  accepts_nested_attributes_for :swigs #, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  #  before_update  :set_lat_lng

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

  def set_coordinates
    begin
      geo = Geocoder.coordinates("#{self.address},#{self.zip_code},#{self.city}, US")
#      geo = Geocoder.coordinates("#{self.address},#{self.city},#{self.zip_code}, US")
      self.latitude = geo.first
      self.longitude = geo.last
    rescue
      self.latitude = nil
      self.longitude = nil
      logger.error "failed to get coordinates"
    end
  end

  def set_http_website
    self.website_link = "http://#{self.website_link}" if !self.website_link.blank? and !self.website_link.include?("http://")
    self.facebook_link = "http://#{self.facebook_link}" if !self.facebook_link.blank? and !self.facebook_link.include?("http://")
    self.twitter_link = "http://#{self.twitter_link}" if !self.twitter_link.blank? and !self.twitter_link.include?("http://")
    self.google_plus_link = "http://#{self.google_plus_link}" if !self.google_plus_link.blank? and !self.google_plus_link.include?("http://")
  end
end
