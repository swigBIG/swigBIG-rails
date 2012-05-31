class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  after_create :get_loyalty

  scope :today, where("created_at >= ? AND created_at  <= ?", Date.today.to_time.in_time_zone.beginning_of_day,  Date.today.to_time.in_time_zone.end_of_day)
  
  def get_loyalty
    today_swiger = self.bar.swigers.today.count
    today_swigs = self.bar.swigs.today.big.lock_status_active.where("people <= ?", today_swiger)
    
    today_swigs.each do |swig|
      swig.update_attributes(lock_status: "unlock")
      swig.today_swiger.each do |swiger|
        swiger.update(swig_message: "test")
      end
    end
    unless self.bar.loyalty.blank?
#      Point.create(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1)
      loyalty_points = Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).count
      if self.bar.loyalty.swigs_number.eql?(loyalty_points)
        Winner.create(bar_id: self.bar_id, user_id: self.user_id)
        Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).delete_all
      end
    end
  end

end
