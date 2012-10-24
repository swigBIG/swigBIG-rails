class Swiger < ActiveRecord::Base
  require 'chronic'

  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  has_many :popularity_guesses
  
  validate :time_and_distance_valid? #, :popularity_reward_valid?

  after_create :unlock_bigswig, :get_loyalty, :get_popularity_reward


  scope :today, where("created_at >= ? AND created_at  <= ?", Time.zone.now.beginning_of_day,  Time.zone.now.end_of_day)

  def get_loyalty
    today_swiger = self.bar.swigers.today
    today_swigs = self.bar.swigs.today.big.lock_status_active.where("people <= ?", today_swiger.count)
    unless self.bar.loyalty.blank?
      loyalty_points = Point.where(bar_id:  self.bar_id, user_id: self.user_id, loyalty_points: 1).count
      loyalty_points = self.user.points.where(bar_id:  self.bar_id, loyalty_points: 1).count
      #      if self.bar.loyalty.swigs_number.eql?(loyalty_points)
      if self.bar.loyalty.swigs_number >= loyalty_points
        ActivityStream.create(activity: "winloyalty", verb: "loyalty reward", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
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
        self.bar.send_message(self.user, {
            topic: "You got loyalty reward from #{self.bar.name}",
            body: "You got loyalty reward from #{self.bar.name} and your coupon: #{serial}",
            category: 16, coupon: serial, coupon_status: false,
            reward: self.bar.loyalty.reward_detail,
            expirate_reward: (self.created_at + (RewardPolicy.first.loyalty_expirate_date rescue 10).to_i.days)
          })
        unless self.user.access_token.blank?
          if self.user.lock_fb_post
            begin
              me = FbGraph::User.me(user.access_token)
              me.feed!(
                :message => "#{self.user.name} just earned #{self.bar.loyalty.reward_detail} at #{self.bar.name} for going there way too much!"
              )
            rescue 
            end
          end
        end
      end
    end
  end

  def time_and_distance_valid?
    #    bar_hour = self.bar.bar_hours.where(day: Time.now.in_time_zone.strftime("%A")).first rescue nil
    bar_hour = self.bar.bar_hours.where(day: Time.zone.now.strftime("%A")).first rescue nil
    if bar_hour.blank?
      self.errors.add("time and distance","#{self.bar.name} not set work hours yet!")
    else
      if !bar_hour.open_time.blank? && !bar_hour.close_time.blank?
        Chronic.time_class = Time.zone
        if (Chronic.parse(bar_hour.close_time) - Chronic.parse(bar_hour.open_time)) < 0
          bar_hour.close_time = Chronic.parse(bar_hour.close_time) + 1.days
        else
          if bar_hour.close_time.eql?("12AM")
            bar_hour.close_time = Chronic.parse("11:59AM")
          elsif bar_hour.close_time.eql?("12PM")
            bar_hour.close_time = Chronic.parse("11:59PM")
          else
            bar_hour.close_time = Chronic.parse(bar_hour.close_time)
          end
        end

        if bar_hour.open_time.eql?("Close")
          self.errors.add("time and distance", "#{self.bar.name} is Close!")
        elsif (Chronic.parse("now") >= Chronic.parse(bar_hour.open_time)) && (Chronic.parse("now") <= bar_hour.close_time)
          user_swig = self.user.swigers.last
          radius = BarRadius.where(status: true).first.distance rescue 1
          unless user_swig.blank?
            time_between_swigging = (TimeSwigging.first.time_between_swig rescue 1) * 3600
            #            time_between_swigging = (RewardPolicy.first.time_between_swig.blank? ?  RewardPolicy.first.time_between_swig :  1)   * 3600
            if (Chronic.parse("now") - user_swig.created_at) >= time_between_swigging
              ActivityStream.create(activity: "swiging", verb: "user swiging", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
              swigging_post_to_wall
              return true
            else
              unless user_swig.bar.latitude.eql?(self.bar.latitude)
                unless (Geocoder::Calculations.distance_between([user_swig.bar.latitude, user_swig.bar.longitude], [self.bar.latitude, self.bar.longitude])) <= (radius)
                  swigging_post_to_wall
                  return true
                else
                  self.errors.add("time and distance", "Permision denied(Near Bar)! you must swigging at another bar atleast #{radius}.miles.")
                end
              else
                self.errors.add("time and distance", "You already Swigged in the last hour, please wait #{((((TimeSwigging.first.time_between_swig rescue 1) * 60) - (Time.zone.now - user_swig.created_at) / 60)).to_i} minutes and try again. You can also try a bar at least #{radius} miles from your last Swig.")
              end
            end
          else
            ActivityStream.create(activity: "swiging", verb: "user swiging", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
            swigging_post_to_wall
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

  #  def popularity_reward_valid?
  #    if !self.bar.popularity.blank?
  #
  #      if !self.user.popularity_inviters.today.first.blank?
  #        self.user.popularity_guesses.today.where(bar_id: self.bar).first.update_attributes(enter_status: "swig")
  #        debugger
  #        popularity_numbers = self.user.popularity_guesses.first.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
  #        if self.bar.popularity.swigs_number.eql?(popularity_numbers)
  #          self.bar.send_message(self.user, {topic: "#{self.user.name} has unlock #{self.bar} popularity", body: ""})
  #          ActivityStream.create(activity: "winpopularity", verb: "popularity reward", actor_id: self.user.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
  #        end
  #      elsif !self.user.popularity_guesses.today.where(bar_id: self.bar).first.blank?
  #        user_guess = self.user.popularity_guesses.today.where(bar_id: self.bar).first
  #        user_guess.update_attributes(enter_status: "swig")
  #        popularity_numbers = user_guess.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
  #      else
  #        return true
  #      end
  #
  #    else
  #      return true
  #    end
  #  end

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
          if self.user.fb_post_swig.blank?
            me = FbGraph::User.me(user.access_token)
            me.feed!(
              :message => "#{user.name} just unlocked #{swig.deal} at #{swig.bar.name} !"
            )
          end
        end
      end
    end
  end

  def swigging_post_to_wall
    self.user.points.create(bar_id: self.bar.id, loyalty_points: 1 ) unless self.bar.loyalty.blank?
    unless self.user.access_token.blank?
      if self.user.fb_post_swig
        me = FbGraph::User.me(user.access_token)
        me.feed!(
          :message => "#{self.user.name} just swigged at #{self.bar.name} !"
        )
      end
    end
  end

  def get_popularity_reward
    unless self.bar.popularity.blank?
      popularity_invitation = self.user.popularity_guesses.today.where(bar_id: self.bar).first
      unless popularity_invitation.blank?
        popularity_invitation.update_attributes(enter_status: "swig")
        popularity_numbers = popularity_invitation.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
        if self.bar.popularity.swigs_number.eql?(popularity_numbers)
          inviter  = popularity_invitation.popularity_inviter.user
          #          self.bar.send_message(inviter, {topic: "#{inviter.name} has unlock #{self.bar} popularity", body: "", category: 9})
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
          #          debugger
          self.bar.send_message(inviter, {
              topic: "You got popularity reward from #{self.bar.name}",
              body: "You got popularity reward from #{self.bar.name} and your coupon: #{serial}",
              category: 9, coupon: serial, coupon_status: false,
              reward: self.bar.popularity.reward_detail,
              expirate_reward: (self.created_at + (RewardPolicy.first.popularity_expirate_hours rescue 10).to_i.hours)
            })
          ActivityStream.create(activity: "winpopularity", verb: "popularity reward", actor_id: inviter.id, actor_type: "User", object_id: self.bar.id, object_type: "Bar")
          if inviter.fb_post_swig
            me = FbGraph::User.me(inviter.access_token)
            me.feed!(
              :message => "#{inviter.name} just earned #{self.bar.popularity.reward_detail} at #{self.bar.name} for being the popular kid on the block!"
            )
          end
          if inviter.fb_id.blank?
            RewardsMessages.popularity_reward_email(inviter, self.bar, serial).deliver
          end
          return true
        end
      else
        return true
      end
    else
      return true
    end

  end

end
