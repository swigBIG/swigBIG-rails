class Users::BarSwigsController < ApplicationController
  layout "bar_profile"

  def index; end

  def show_swig
    @bar = Bar.find(params[:bar_id])
    @products = @bar.products.all
    @swig = @bar.swigs.find(params[:swig_id])
  end

  def enter_bar
    @bar = Bar.find(params[:bar_id])

    if user_signed_in?
      @swiger = @bar.swigers.new(user_id: current_user.id)

      if @swiger.save
        if !@bar.loyalty.blank?
          redirect_to :back, notice: "You added as Swiger in this BigSwig!"
        else
          redirect_to :back, notice: "You added as Swiger in this BigSwig!"
        end
      else
        redirect_to :back, notice: "#{@swiger.errors["time and distance"].first} #{@swiger.errors["time and distance"].first}"
      end
    else
      redirect_to users_enter_bar_path(@bar), notice: "You must sign in first!"
    end
  end

  def mobile_swigging
    
    @bar = Bar.find(params[:bar_id])
    
    if user_signed_in?
      swiger = @bar.swigers.new(user_id: current_user.id)
      if swiger.save
        unless current_user.access_token.blank?
          redirect_to users_mobile_invite_fb_friends_url(@bar, :mobile), notice:  "Thank you for Swigging!"
        else
          redirect_to users_mobile_invite_email_friends_url(@bar, :mobile), notice:  "Thank you for Swigging!"
        end
      else
        redirect_to :back, notice: "#{swiger.errors["time and distance"].first}"
      end
    else
      redirect_to users_enter_bar_path(@bar, :mobile), notice: "You must sign in first!"
    end

  end

  def mobile_invite_fb_friends
    @bar = Bar.find(params[:bar_id])
    @loyalty_points = current_user.points.where(bar_id: @bar.id).first rescue nil
    unless current_user.popularity_guesses.today.first.blank?
      @inviter = current_user.popularity_guesses.today.first.popularity_inviter
      @popularity_guesses_point = current_user.popularity_guesses.today.first.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
    end

    @reward = current_user.messages.where(category: [5, 9, 16, 1]).where(['expirate_reward > ? ', Time.zone.now]).order(:expirate_reward).count
    #              current_user.messages.where(category: [5, 9, 16, 1]).where(['expirate_reward > ? ', Time.zone.now]).order(:expirate_reward)
    @reward_to_expirate = current_user.messages.where(["expirate_reward <= ? AND expirate_reward > ?", @expirate_within_to_expire.days.from_now, Time.zone.now]).order(:expirate_reward).count
    @friends = FbGraph::User.me(current_user.access_token).friends.sort_by(&:name)
  end

  def mobile_invite_email_friends
    @bar = Bar.find(params[:bar_id])
    @loyalty_points = current_user.points.where(bar_id: @bar.id).first
    unless current_user.popularity_guesses.today.first.blank?
      @inviter = current_user.popularity_guesses.today.first.popularity_inviter
      @popularity_guesses_point = current_user.popularity_guesses.today.first.popularity_inviter.popularity_guesses.where(enter_status: "swig").count
    end
    @reward = current_user.messages.where(category: [9, 16]).where(['expirate_reward > ? ', Time.zone.now]).order(:expirate_reward).count
    @reward_to_expirate = current_user.messages.where(["expirate_reward <= ? AND expirate_reward > ?", @expirate_within_to_expire.days.from_now, Time.zone.now]).order(:expirate_reward).count
  end

  #  def invite_fb_friends
  #    fb = MiniFB::OAuthSession.new(current_user.access_token)
  #    params[:fb_ids].each do |fb_id|
  #      fb.post(fb_id, :type => :feed, :params => {:message => "#{current_user.name} invite you to visit http://swigbig.com/"})
  #    end
  #    redirect_to :back, notice: "invite success"
  #  end

  def invite_fb_friends
    fb = MiniFB::OAuthSession.new(current_user.access_token)
    bar = Bar.find(params[:bar_id])

    if current_user.popularity_inviters.where(bar_id: bar.id).where("created_at <= ? AND created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date ).blank?
      popularity_inviter = bar.popularity_inviters.new(user_id: current_user.id, fb_id: current_user.fb_id )
      
      if !params[:fb_ids].blank? and popularity_inviter.save

        fb_friends = params[:fb_ids]
        if current_user.popularity_guesses.where(bar_id: bar.id).where("created_at <= ? AND created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date).blank?
          fb_friends = params[:fb_ids]
        else
          inviters = current_user.popularity_guesses.joins(:popularity_inviter).where(bar_id: bar.id).where("popularity_guesses.created_at <= ? AND popularity_guesses.created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date).pluck('popularity_inviters.fb_id')
          fb_friends = fb_friends - inviters
        end

        #        unless fb_friends.blank?
        fb_friends.each do |fb_id|
          fb.post(fb_id, :type => :feed, :params => {:message => "invite you join them at #{bar.name} via http://swigbig.com/"})
          user = User.where(fb_id: fb_id).first
          if user
            popularity_inviter.popularity_guesses.create(user_id: user.id, email: user.email,fb_id: fb_id, bar_id: popularity_inviter.bar_id)
          else
            popularity_inviter.popularity_guesses.create(user_id: nil, email: nil ,fb_id: fb_id, bar_id: popularity_inviter.bar_id)
          end
        end
        redirect_to users_bar_profile_url(bar, :mobile), notice: "Success Create Popularity!"
        #        else
        #          redirect_to users_bar_profile_url(bar, :mobile), notice: "Fail Create Popularity! need friends to invite!"
        #        end
      else
        redirect_to :back, notice: "Fail Create Popularity! Please check your Guesses!"
      end
    else
      inviter  = current_user.popularity_inviters.today.where(bar_id: bar.id).first

      fb_friends = params[:fb_ids]
      if current_user.popularity_guesses.where(bar_id: bar.id).where("created_at <= ? AND created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date).blank?
        fb_friends = params[:fb_ids]
      else
        inviters = current_user.popularity_guesses.joins(:popularity_inviter).where(bar_id: bar.id).where("popularity_guesses.created_at <= ? AND popularity_guesses.created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date).pluck('popularity_inviters.fb_id')
        fb_friends = fb_friends - inviters
      end

      fb_friends.each do |fb_id|
        begin
          fb.post(fb_id, :type => :feed, :params => {:message => "invite you join them at #{bar.name} via http://swigbig.com/"})
          user = User.where(fb_id: fb_id).first
          guess = inviter.popularity_guesses.where(fb_id: fb_id).first
          if user and !guess
            inviter.popularity_guesses.create(user_id: user.id, email: user.email,fb_id: fb_id, bar_id: bar.id)
          elsif !user
            inviter.popularity_guesses.create(user_id: nil, email: nil ,fb_id: fb_id, bar_id: bar.id)
          elsif guess
          end
        rescue
          
        end
      end
      redirect_to users_bar_profile_url(bar, :mobile), notice: "Success Create Popularity!"
    end

  end

  def invite_email_friends
    bar = Bar.find(params[:bar_id])
    if current_user.popularity_inviters.where(bar_id: bar.id).where("created_at <= ? AND created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date ).blank?
      popularity_inviter = bar.popularity_inviters.new(user_id: current_user.id, email: current_user.email )
      if !params[:mytags].blank? and popularity_inviter.save

        email_friends = params[:mytags].split(",")
        if current_user.popularity_guesses.where(bar_id: bar.id).where("created_at <= ? AND created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date).blank?
          email_friends = params[:mytags].split(",")
        else
          inviters = current_user.popularity_guesses.joins(:popularity_inviter).where(bar_id: bar.id).where("popularity_guesses.created_at <= ? AND popularity_guesses.created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date).pluck('popularity_inviters.email')
          email_friends = email_friends - inviters
        end

        email_friends.each do |email|
          Invite.send_invite_email(email, current_user, bar).deliver
          user = User.where(email: email).first
          if user
            popularity_inviter.popularity_guesses.create(user_id: user.id, email: email, bar_id: popularity_inviter.bar_id)
          else
            popularity_inviter.popularity_guesses.create(user_id: nil, email: email, bar_id: popularity_inviter.bar_id)
          end
        end
        
        redirect_to users_bar_profile_url(bar, :mobile), notice: "Success Create Popularity!"
      else
        redirect_to :back, notice: "Fail Create Popularity! or no guess that you add!"
      end
      
    else
      inviter  = current_user.popularity_inviters.today.where(bar_id: bar.id).first
      if !params[:mytags].blank?
        params[:mytags].split(",").each do |email|
          Invite.send_invite_email(email, current_user, bar).deliver
          user = User.where(email: email).first
          guess = inviter.popularity_guesses.where(email: email).first
          if user and !guess
            inviter.popularity_guesses.create(user_id: user.id, email: email, bar_id: bar.id)
          elsif !user
            inviter.popularity_guesses.create(user_id: nil, email: email, bar_id: bar.id)
          elsif guess
          end
        end
      end
      redirect_to users_bar_profile_url(bar, :mobile), notice: "Success Create Popularity!"
    end
  end

end