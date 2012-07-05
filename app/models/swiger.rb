class Swiger < ActiveRecord::Base
  require 'chronic'

  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  #  before_create :check_swiger
  after_create :get_loyalty

  validate :time_and_distance_valid?

  #  scope :today, where("created_at >= ? AND created_at  <= ?", Date.today.to_time.in_time_zone.beginning_of_day,  Date.today.to_time.in_time_zone.end_of_day)

  scope :today, where("created_at >= ? AND created_at  <= ?", Time.zone.now.beginning_of_day,  Time.zone.now.end_of_day)

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
    user = User.find(actor)
    self.bar.send_message(user, {topic: "Loyalty winner", body: "You win Loyalty reward from #{self.bar.name}"})
  end


  def time_and_distance_valid?
    bar_hour = self.bar.bar_hours.where(day: Time.now.to_time.in_time_zone.strftime("%A")).first
    unless bar_hour.open_time.blank? && bar_hour.close_time.blank?
#      debugger
      Chronic.time_class = Time.zone
      if (Date.today.to_time.in_time_zone >= Chronic.parse(bar_hour.open_time.gsub(".0",""))) && (Date.today.to_time.in_time_zone <= Chronic.parse(bar_hour.close_time.gsub(".0","")))
        user_swig = self.user.swigers.last
        radius = BarRadius.where(status: true).first.distance
        unless user_swig.blank?
          if (Time.now.to_time.in_time_zone - user_swig.created_at.to_time.in_time_zone) >= 3600
            return true
          else
            unless user_swig.bar.latitude.eql?(self.bar.latitude)
              unless (Geocoder::Calculations.distance_between([user_swig.bar.latitude, user_swig.bar.longitude], [self.bar.latitude, self.bar.longitude])) <= (radius)
                return true
              else
                self.errors.add("time and distance", "Permision denied(Near Bar)!")
              end
            else
              self.errors.add("time and distance", "You already Swigged in the last hour, please wait #{((60 - (Time.now.to_time.in_time_zone - user_swig.created_at.to_time.in_time_zone) / 60)).to_i} minutes and try again. You can also try a bar at least #{radius} miles from your last Swig.")
            end
          end
        else
          return true
        end
      else
        self.errors.add("time and distance","#{self.bar.name} is not open yet, please Swig at #{bar_hour.open_time} - #{bar_hour.close_time}")
      end
    else
      self.errors.add("time and distance","#{self.bar.name} not set work hours yet!")
    end
  end

#  def popularity_reward_valid?
##    user_guesses = self.user.popularity_inviters.today.last.users_inviters_id.split(",")
#
#
#    today_friends_swiger = self.bar.swigers.today.where(user_id: user_guesses).count
#    if self.user.popularity_inviters.today.last.blank
#    unless self.bar.popularity.blank?
#      if self.bar.popularity.swigs_number.eql?(today_friends_swiger)
#        User.where(id: user_guesses).each do |user|
#          self.bar.send_message(user, {topic: "Loyalty winner", body: "You win Loyalty reward from #{self.bar.name}"})
#        end
#      else
#        self.errors.add("popularity reward","#{self.bar.name} popularity not archive yet!!")
#      end
#    else
#      self.errors.add("popularity reward","#{self.bar.name} not create popularity yet!!")
#    end
#  end



end
