class City < ActiveRecord::Base
  attr_accessible :integer, :name, :site_content_id, :state, :country

  belongs_to :site_content

  extend  FriendlyId

  friendly_id :name , use: :slugged

  before_save  :set_city_lat_lng

  def set_city_lat_lng
    begin
      coordinates = Geocoder.coordinates("#{self.name}, #{self.state}, #{self.country}")
      self.latitude = coordinates.first
      self.longitude = coordinates.last
    rescue
      self.latitude = nil
      self.longitude = nil
      logger.error "failed to get coordinates"
    end
  end
  
end
