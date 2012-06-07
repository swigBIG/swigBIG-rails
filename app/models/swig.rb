class Swig < ActiveRecord::Base

  attr_accessible :bar_id, :deal, :people, :status, :swig_day, :swig_type, :product_id, :swig_price,
    :lock_status, :latitude, :longitude, :address, :city, :full_address, :zip_code

  belongs_to :bar
  with_options dependent: :destroy do
    #    has_many :swigers
  end

  before_save :add_address

  geocoded_by :address

  scope :today, where(swig_day: Date.today.to_time.in_time_zone.strftime("%A"))
  scope :big, where(swig_type: "Big")
  scope :lock_status_active, where(status: "active")
  #days
  scope :monday, where("swig_day = 'Monday'")
  scope :tuesday, where("swig_day = 'Tuesday'")
  scope :wednesday, where("swig_day = 'Wednesday'")
  scope :thursday, where("swig_day = 'Thursday'")
  scope :friday, where("swig_day = 'Friday'")
  scope :saturday, where("swig_day = 'Saturday'")
  scope :sunday, where("swig_day = 'Sunday'")
  def swig_lock
    self.people
  end

  def add_address
    begin
      self.address = self.bar.address
      self.city = self.bar.city
      self.latitude = self.bar.latitude
      self.longitude = self.bar.longitude
      self.zip_code = self.bar.zip_code
      self.full_address = self.bar.full_address
    rescue
      self.address = nil
      self.city = nil
      self.latitude = nil
      self.longitude = nil
      logger.error "failed to get coordinates"
    end
  end

end
