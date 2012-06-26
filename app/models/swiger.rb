class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  before_create :check_swiger
  after_create :get_loyalty

  scope :today, where("created_at >= ? AND created_at  <= ?", Date.today.to_time.in_time_zone.beginning_of_day,  Date.today.to_time.in_time_zone.end_of_day)


  #  log_activity_streams self.user_id, :name, "test",
  #    :loyalty_points, :id, :get_loyalty, :swig
  def get_loyalty
    today_swiger = self.bar.swigers.today
    today_swigs = self.bar.swigs.today.big.lock_status_active.where("people <= ?", today_swiger.count)
    
    today_swigs.each do |swig|
      swig.update_attributes(lock_status: "unlock")
      swig.today_swiger.pluck(:user_id).each do |swiger|
        user = User.find(swiger)
        self.bar.send_message(user, {topic: "#{swig.deal} unlock", body: "You Unlock #{swig.deal}"})
      end
    end
    unless self.bar.loyalty.blank?
      #      Point.create(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1)
      loyalty_points = Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).count
      if self.bar.loyalty.swigs_number.eql?(loyalty_points)
        win = Winner.create(bar_id: self.bar_id, user_id: self.user_id)
        create_activity(self.user_id, win.id)
        Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).delete_all
      end
    end
  end


  def create_activity(actor, object)
    ActivityStream.create(activity: "winloyalty", verb: "Winner Confirmation", actor_id: actor, actor_type: "User", object_id: object, object_type: "Winner")
  end

  def check_swiger
    user_swig = self.user.swigers.last
    radius = BarRadius.where(status: true).first.distance

    if (Time.now.to_time.in_time_zone - user_swig.created_at.to_time.in_time_zone) >= 3600
      return true
    else
      unless user_swig.bar.latitude.eql?(self.bar.latitude)
        if (Geocoder::Calculations.distance_between([user_swig.bar.latitude, user_swig.bar.longitude], [self.bar.latitude, self.bar.longitude])) <= (radius)
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end

end
