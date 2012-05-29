class Swig < ActiveRecord::Base

  attr_accessible :bar_id, :deal, :people, :status, :swig_day, :swig_type, :product_id, :swig_price,
    :lock_status, :latitude, :longitude, :address, :city

  belongs_to :bar
  with_options dependent: :destroy do
    #    has_many :swigers
  end

  before_save :add_address

  geocoded_by :address

  scope :today, where(swig_day: Date.today.strftime("%A"))
  scope :big, where(swig_type: "Big")
  scope :lock_status_active, where(status: "active")
  #days
  scope :monday, where("swig_day = 'Monday' OR swig_day = 'all'")
  scope :tuesday, where("swig_day = 'Tuesday' OR swig_day = 'all'")
  scope :wednesday, where("swig_day = 'Wednesday' OR swig_day = 'all'")
  scope :thursday, where("swig_day = 'Thursday' OR swig_day = 'all'")
  scope :friday, where("swig_day = 'Friday' OR swig_day = 'all'")
  scope :saturday, where("swig_day = 'Saturday' OR swig_day = 'all'")
  scope :sunday, where("swig_day = 'Sunday' OR swig_day = 'all'")
  def swig_lock
    self.people
  end

  def add_address
    begin
      self.address = self.bar.address
      self.city = self.bar.city
      self.latitude = self.bar.latitude
      self.longitude = self.bar.longitude
    rescue
      self.address = nil
      self.city = nil
      self.latitude = nil
      self.longitude = nil
      logger.error "failed to get coordinates"
    end
  end

end
