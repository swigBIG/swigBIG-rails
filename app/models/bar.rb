require 'geokit'
require 'geokit-rails3'
include GeoKit::Geocoders
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
    :bar_hours_attributes, :full_address, :sports_team_list, :lock_status
  
  validates :terms, :acceptance => true
  validates :address, :zip_code, :city, :presence => true, :on => :update
  #  validates :zip_code, format: {:with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234"}, :on => :update

  before_update  :set_http_website
  before_validation :set_full_address, :locate

  geocoded_by :address

  extend  FriendlyId
  friendly_id :name , use: :slugged
  
  acts_as_taggable_on :sports_teams
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

  accepts_nested_attributes_for :bar_hours, :allow_destroy => true
  
  acts_as_mappable :default_units => :miles,
    :default_formula => :sphere,
    :distance_field_name => :distance,
    :lat_column_name => :latitude,
    :lng_column_name => :longitude

  def set_full_address
    unless self.address.blank?
      self.full_address = "#{self.address},#{self.city},#{self.zip_code}, United States"
    end
  end

  def locate
    unless self.address.blank? 
      loc = MultiGeocoder.geocode(set_full_address)
      if loc.success
        self.latitude = loc.lat
        self.longitude = loc.lng
      end
    end
  end

  def set_http_website
    self.website_link = "http://#{self.website_link}" if !self.website_link.blank? and !self.website_link.include?("http://")
    self.facebook_link = "http://#{self.facebook_link}" if !self.facebook_link.blank? and !self.facebook_link.include?("http://")
    self.twitter_link = "http://#{self.twitter_link}" if !self.twitter_link.blank? and !self.twitter_link.include?("http://")
    self.google_plus_link = "http://#{self.google_plus_link}" if !self.google_plus_link.blank? and !self.google_plus_link.include?("http://")
  end

end
