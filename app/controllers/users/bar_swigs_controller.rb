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
#          respond_with LiveSwigging
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
    @loyalty_points = current_user.points.where(bar_id: @bar.id).first
    @reward = current_user.messages.where(category: [9, 16]).where(['expirate_reward > ? ', Time.zone.now]).order(:expirate_reward).count
    @reward_to_expirate = current_user.messages.where(["expirate_reward <= ? AND expirate_reward > ?", @expirate_within_to_expire.days.from_now, Time.zone.now]).order(:expirate_reward).count
    @friends = FbGraph::User.me(current_user.access_token).friends.sort_by(&:name)
  end

  def mobile_invite_email_friends
    @bar = Bar.find(params[:bar_id])
    @loyalty_points = current_user.points.where(bar_id: @bar.id).first
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
    popularity_inviter = bar.popularity_inviters.new(user_id: current_user.id )
    if popularity_inviter.save and !params[:fb_ids].blank?
      popularity_inviter.popularity_guesses.create(user_id: current_user.id, bar_id: popularity_inviter.bar_id, fb_id: current_user.fb_id, enter_status: "swig")
      params[:fb_ids].each do |fb_id|
        fb.post(fb_id, :type => :feed, :params => {:message => "invite you join them at #{bar.name} via http://swigbig.com/"})
        user = User.where(fb_id: fb_id).first
        if user
          popularity_inviter.popularity_guesses.create(user_id: user.id, email: user.email,fb_id: fb_id, bar_id: popularity_inviter.bar_id)
        else
          popularity_inviter.popularity_guesses.create(user_id: nil, email: nil ,fb_id: fb_id, bar_id: popularity_inviter.bar_id)
        end
      end
      redirect_to users_bar_profile_url(bar, :mobile), notice: "Success Create Popularity!"
    else
      redirect_to :back, notice: "Fail Create Popularity! Please check your Guesses!"
    end
  end

  def invite_email_friends
    bar = Bar.find(params[:bar_id])
    popularity_inviter = bar.popularity_inviters.new(user_id: current_user.id )
    if popularity_inviter.save and !params[:mytags].blank?
      popularity_inviter.popularity_guesses.create(user_id: current_user.id, bar_id: bar.id, enter_status: "swig")
      params[:mytags].split(",").each do |email|
        Invite.send_invite_email(email, current_user, bar).deliver
        user = User.where(email: email).first
        if user
          popularity_inviter.popularity_guesses.create(user_id: user.id, email: email, bar_id: popularity_inviter.bar_id)
        else
          popularity_inviter.popularity_guesses.create(user_id: nil, email: email, bar_id: popularity_inviter.bar_id)
        end
      end
      redirect_to users_bar_profile_url(bar), notice: "Success Create Popularity!"
    else
      redirect_to :back, notice: "Fail Create Popularity! or no guess that you add!"
    end
  end

end