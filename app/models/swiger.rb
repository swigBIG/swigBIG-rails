class Swiger < ActiveRecord::Base
  require 'chronic'

  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  has_many :popularity_guesses

  #  before_create :check_swiger
  
  validate :time_and_distance_valid?, :popularity_reward_valid?

  after_create :unlock_bigswig, :get_loyalty

  #  scope :today, where("created_at >= ? AND created_at  <= ?", Date.today.to_time.in_time_zone.beginning_of_day,  Date.today.to_time.in_time_zone.end_of_day)

  scope :today, where("created_at >= ? AND created_at  <= ?", Time.zone.now.beginning_of_day,  Time.zone.now.end_of_day)

  def get_loyalty
    today_swiger = self.bar.swigers.today
    today_swigs = self.bar.swigs.today.big.lock_status_active.where("people <= ?", today_swiger.count)
    unless self.bar.loyalty.blank?
      loyalty_points = Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).count
      loyalty_points = self.user.points.where(bar_id:  self.bar_id, loyalty_points: 1).count
      if self.bar.loyalty.swigs_number.eql?(loyalty_points)
        ActivityStream.create(activity: "winloyalty", verb: "loyalty reward", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
        #        create_activity(self.user_id, win.id)
        Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).delete_all
        chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
        serial = (0...20).collect { chars[Kernel.rand(chars.length)] }.join
        is_existed = true
        while is_existed.eql?(true)
          if Coupon.where(coupon_serial: serial).first.nil?
            is_existed = false
          else
            chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
            serial = (0...20).collect { chars[Kernel.rand(chars.length)] }.join
          end
        end
        win = Winner.create(bar_id: self.bar_id, user_id: self.user_id, coupon: serial)
        self.bar.send_message(self.user, {topic: "You got loyalty reward from #{self.bar.name}", body: "You got reward from #{self.bar.name} and your coupon: #{serial}", category: 16, coupon: serial, coupon_status: false, reward: self.bar.loyalty.reward_detail })
      end
    end
  end


  #  def create_activity(actor, object)
  #    ActivityStream.create(activity: "winloyalty", verb: "Winner Confirmation", actor_id: actor, actor_type: "User", object_id: object, object_type: "Winner")
  #    user = User.find(actor)
  #    self.bar.send_message(user, {topic: "Loyalty winner", body: "You win Loyalty reward from #{self.bar.name}"})
  #  end


  def time_and_distance_valid?
    #    bar_hour = self.bar.bar_hours.where(day: Time.now.in_time_zone.strftime("%A")).first rescue nil
    bar_hour = self.bar.bar_hours.where(day: Time.zone.now.strftime("%A")).first rescue nil
    if bar_hour.blank?
      self.errors.add("time and distance","#{self.bar.name} not set work hours yet!")
    else
      if !bar_hour.open_time.blank? && !bar_hour.close_time.blank?
        Chronic.time_class = Time.zone

        if bar_hour.open_word.eql?("PM") and bar_hour.close_word.eql?("AM")
          bar_hour.close_time = Chronic.parse(bar_hour.close_time) + 1.days
        else
          if bar_hour.close_time.eql?("12AM")
            bar_hour.close_time = "11:59AM"
          elsif bar_hour.close_time.eql?("12PM")
            bar_hour.close_time = "11:59PM"
          else
            bar_hour.close_time = bar_hour.close_time
          end
        end

        #      if (Time.zone.now >= Chronic.parse(bar_hour.open_time.gsub(".0",""))) && (Time.zone.now <= Chronic.parse(bar_hour.close_time.gsub(".0","")))
        if bar_hour.open_time.eql?("Close")
          self.errors.add("time and distance", "#{self.bar.name} is Close!")
        elsif (Chronic.parse("now") >= Chronic.parse(bar_hour.open_time.gsub(".0",""))) && (Chronic.parse("now") <= Chronic.parse(bar_hour.close_time))
          user_swig = self.user.swigers.last
          radius = BarRadius.where(status: true).first.distance rescue 25
          unless user_swig.blank?
            if (Time.zone.now - user_swig.created_at) >= 3600
              self.user.points.create(bar_id: self.bar.id, loyalty_points: 1 )
              ActivityStream.create(activity: "swiging", verb: "user swiging", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
              return true
            else
              unless user_swig.bar.latitude.eql?(self.bar.latitude)
                unless (Geocoder::Calculations.distance_between([user_swig.bar.latitude, user_swig.bar.longitude], [self.bar.latitude, self.bar.longitude])) <= (radius)
                  return true
                else
                  self.errors.add("time and distance", "Permision denied(Near Bar)!")
                end
              else
                self.errors.add("time and distance", "You already Swigged in the last hour, please wait #{((60 - (Time.zone.now - user_swig.created_at) / 60)).to_i} minutes and try again. You can also try a bar at least #{radius} miles from your last Swig.")
              end
            end
          else
            self.user.points.create(bar_id: self.bar.id, loyalty_points: 1 )
            ActivityStream.create(activity: "swiging", verb: "user swiging", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
            return true
          end
        else
          self.errors.add("time and distance","#{self.bar.name} is not open yet, please Swig at #{bar_hour.open_time} - #{bar_hour.close_time}")
        end
      else
        self.errors.add("time and distance","#{self.bar.name} not set work hours yet!")
      end
    end
  end

  def popularity_reward_valid?
    if !self.bar.popularity.blank?

      if !self.user.popularity_inviters.today.first.blank?
        self.user.popularity_guesses.today.where(bar_id: self.bar).first.update_attributes(enter_status: "swig")
        popularity_numbers = self.user.popularity_guesses.first.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
        if self.bar.popularity.swigs_number.eql?(popularity_numbers)
          self.bar.send_message(self.user, {topic: "#{self.user.name} has unlock #{self.bar} popularity", body: ""})
          ActivityStream.create(activity: "winpopularity", verb: "popularity reward", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
          #            self.user.popularity_guesses.today.first.popularity_inviter.popularity_guesses.where(enter_status: "swig").select(:user_id).each do |guess|
          #            self.bar.send_message(guess.user, {topic: "#{self.user.name} has unlock #{self.bar} popularity", body: ""})
          #          end
        end
      elsif !self.user.popularity_guesses.today.where(bar_id: self.bar).first.blank?
        user_guess = self.user.popularity_guesses.today.where(bar_id: self.bar).first
        user_guess.update_attributes(enter_status: "swig")
        popularity_numbers = user_guess.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
        #        if self.bar.popularity.swigs_number.eql?(popularity_numbers)
        #          self.user.popularity_guesses.today.first.popularity_inviter.popularity_guesses.where(enter_status: "swig").select(:user_id).each do |guess|
        #            self.bar.send_message(guess.user, {topic: "#{self.bar.name} popularity has unlock", body: "You can get our Popularity reward #{self.bar.popularity.reward_detail}", category: 9})
        #          end
        #        end
      else
        return true
      end

    else
      return true
    end
  end

  def unlock_bigswig
    today_swiger = self.bar.swigers.today
    today_swigs = self.bar.swigs.today.big.where("people <= ?", today_swiger.count)
    today_swigs.each do |swig|
      swig.update_attributes(lock_status: "unlock")
      today_swiger.pluck(:user_id).each do |swiger|
        user = User.find(swiger)
        self.bar.send_message(user, {topic: "Unlock #{self.bar.name}'s BigSWIG", body: "You Unlock #{swig.deal} at #{self.bar.name}", category: 15})
        ActivityStream.create(activity: "bigswig unlock", verb: "bigswig unlock", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
        unless user.access_token.blank?
          me = FbGraph::User.me(user.access_token)
          me.feed!(
            :message => "#{user.name} just earned #{swig.deal} at #{swig.bar.name}"
          )
        end

      end
    end
  end

end
