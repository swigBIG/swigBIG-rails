class Users::DashboardController < ApplicationController
  before_filter :authenticate_user!

  layout "users_no_side"

  def index
    @user = current_user
    @top_bar = current_user.swigers.select(:bar_id).group(:bar_id).max.bar.name rescue "Not Swigging Yet!"
    @top_city = current_user.swigers.select(:bar_id).group(:bar_id).max.bar.city rescue "Not Swigging Yet!"
    @total_swig = current_user.swigers.count
    @total_rewards = current_user.messages.where(category: [1,5, 9, 16])
  end

  def facebook_page
    if is_mobile_view? and !user_signed_in?
      redirect_to mobile_dashboard_home_url(:mobile)
    end
    @top_bar = Swiger.select(:bar_id).group(:bar_id).max
    @swigers = Swiger.where(user_id: current_user).order("created_at DESC")
    @bars = Bar.all
    bar_ids =  Bar.within( @radius_for_swigger, origin: [@city_lat_lng[1], @city_lat_lng[2]]).pluck(:id)
    fb_ids = FbGraph::User.me(current_user.access_token).friends.map(&:identifier)
    fb_friends_ids = User.where(fb_id: fb_ids).pluck(:fb_id)
    @friends_swigger = Swiger.joins(:user).where(["users.fb_id IN (?) AND swigers.created_at >= (?) AND swigers.created_at <= (?)", fb_friends_ids, Time.zone.now.beginning_of_day, Time.zone.now.end_of_day ])
    #    @friends_swigger = Swiger.joins(:user).where(["users.fb_id IN (?) AND swigers.created_at >= (?) AND swigers.created_at <= (?)", fb_friends_ids,( Time.zone.now - @swigger_show_within ), Time.zone.now ])

    #      @friends_swigger = Swiger.joins(:user).where(["users.email IN (?) AND swigers.created_at >= (?) AND swigers.created_at <= (?)", emails, Time.now.beginning_of_day, Time.now.end_of_day ])
    @user = User.new
    @friends = FbGraph::User.me(current_user.access_token).friends#.sort_by(&:name)
  end

  def facebook_update_status
    me = FbGraph::User.me(current_user.access_token)
    me.feed!(
      :message => params[:message]
    )
    redirect_to :back
  end

  #  def invite_swigbig
  #    fb = MiniFB::OAuthSession.new(current_user.access_token)
  #
  #    params[:fb_ids].each do |fb_id|
  #      fb.post(fb_id, :type => :feed, :params => {:message => "#{current_user.name} invite you to visit http://swigbig.com/"})
  #    end
  #
  #    redirect_to :back, notice: "invite success"
  #  end
  
  def invite_swigbig
    fb = MiniFB::OAuthSession.new(current_user.access_token)
    #    @bar = Bar.find(params[:bar_ids][:bar_id])
    @bar = Bar.find(params[:bar_id])
    @popularity_inviter = @bar.popularity_inviters.new(user_id: current_user.id )
    if @popularity_inviter.save
      if  !params[:fb_ids].blank?
        @popularity_inviter.popularity_guesses.create(user_id: current_user.id, bar_id: @popularity_inviter.bar_id, fb_id: current_user.fb_id)
        params[:fb_ids].each do |fb_id|
          #          unless User.where(fb_id: fb_id).first.blank?
          fb.post(fb_id, :type => :feed, :params => {:message => "#{current_user.name} invite you to visit #{@bar.name} or join http://swigbig.com/"})
          user = User.where(fb_id: fb_id).first
          if user
            @popularity_inviter.popularity_guesses.create(user_id: user.id, email: user.email,fb_id: fb_id, bar_id: @popularity_inviter.bar_id)
          else
            @popularity_inviter.popularity_guesses.create(user_id: nil, email: nil ,fb_id: fb_id, bar_id: @popularity_inviter.bar_id)
          end
          #          end
        end
        redirect_to :back, notice: "Success Create Popularity!"
      else
        @popularity_inviter.destroy
        redirect_to :back, notice: "Empty Guess!"
      end
    else
      redirect_to :back, notice: "Fail Create Popularity!"
    end
  end

  #  def invite_by_email
  #    params[:mytags].each do |e|
  #      Invite.send_invite_email(e, current_user).deliver
  #    end
  #
  #    redirect_to :back, notice: "invite has been sent"
  #  end

  def invite_by_email
    @bar = Bar.find(params[:bar_ids][:bar_id])
    @popularity_inviter = @bar.popularity_inviters.new(user_id: current_user.id )
    if @popularity_inviter.save
      if  !params[:mytags].blank?
        @popularity_inviter.popularity_guesses.create(user_id: current_user.id, bar_id: @popularity_inviter.bar_id, fb_id: current_user.fb_id)
        params[:mytags].split(",").each do |email|
          Invite.send_invite_email(email, current_user, @bar).deliver
          user = User.where(email: email).first
          if user
            @popularity_inviter.popularity_guesses.create(user_id: user.id, email: email, bar_id: @popularity_inviter.bar_id)
          else
            @popularity_inviter.popularity_guesses.create(user_id: nil, email: email, bar_id: @popularity_inviter.bar_id)
          end
        end
        redirect_to :back, notice: "Success Create Popularity!"
      else
        @popularity_inviter.destroy
        redirect_to :back, notice: "Empty Guess!"
      end
    else
      redirect_to :back, notice: "Fail Create Popularity!"
    end
  end

  def costum_invite
    @fb = MiniFB::OAuthSession.new(self.auth_token)
    @fb.post(fb_id, :type => :feed, :params => {:message => params[:message]})
  end

  def show
    @top_bar = current_user.swigers.select(:bar_id).group(:bar_id).max.bar.name rescue "never swigging yet!"
    @swigers = Swiger.where(user_id: current_user).order("created_at DESC")
    @bars = Bar.all
    @user = User.new
    @users = User.all
    @friends = current_user.friends
    bar_ids =  Bar.within( @radius_for_swigger, origin: [@city_lat_lng[1], @city_lat_lng[2]]).pluck(:id)
    @friends_swigger = Swiger.today.where(["bar_id IN (?)", bar_ids])
    #    @winners = Winner.where(user_id: current_user)
  end

  def rewards
    @bar_rewards = current_user.received_messages.where(["coupon_status = false AND category = ? OR category = ?", 9, 15]).order("created_at DESC").page(params[:page]).per(5)
    @winners = current_user.winners
    @loyalty_points = current_user.points.group(:bar_id)
    @populrity_points = current_user.popularity_inviters.today
    #    @rewards = current_user.received_messages.where(coupon_status: false).where(["expirate_reward <= ? AND expirate_reward > ? AND category = ? OR category = ? OR category = ?", @expirate_within_to_expire.days.from_now, Time.zone.now, 9, 15, 16]).order("expirate_reward ASC").page(params[:page]).per(5)
    @rewards = current_user.messages.where(category: [5, 9, 16, 1]).where(['expirate_reward > ? ', Time.zone.now]).order(:expirate_reward).page(params[:page]).per(5)
    @redeem_rewards = current_user.received_messages.where(coupon_status: true).where(["category = ? OR category = ? OR category = ?", 9, 15, 16]).order("created_at DESC").page(params[:page]).per(5)
  end

  def update_account
    @user = current_user
    if @user.update_attributes(params[:user])
      sign_in @user, :bypass => true
      redirect_to :back, notice: "Update Success!"
    else
      redirect_to :back, notice: "Update Failed!"
    end
  end

  def update_password
    @user = User.find(current_user.id)
    
    if @user.update_attributes(params[:user])
      sign_in @user, :bypass => true
      msg = "Update Success!"
    else
      msg = "Update Failed!"
    end

    redirect_to :back, notice: msg
  end

  def completion
    @user = current_user
  end

  def update_completion
    user = current_user
    #    if (Time.now.to_date.year - params[:user][:bird_date].to_date.year) >= 21
    if (Time.now.to_date.year - "#{params[:user]["bird_date(3i)"]}-#{params[:user]["bird_date(2i)"]}-#{params[:user]["bird_date(1i)"]}".to_date.year) >= 21
      if user.update_attributes(avatar: params[:user][:avatar] , phone_number: params[:user][:phone_number] , address: params[:user][:address], zip_code: params[:user][:zip_code], city: params[:user][:city], state: params[:user][:state], bird_date: "#{params[:user]["bird_date(3i)"]}-#{params[:user]["bird_date(2i)"]}-#{params[:user]["bird_date(1i)"]}".to_date )
        sign_in user, :bypass => true
        redirect_to root_path, notice: "Profile Completion Success!"
      else
        redirect_to :back, notice: "Profile Completion Failed!"
      end
    else
      user.destroy
      redirect_to :root, notice: "Age under 21 can't register!"
    end
  end

  def after_join_invite_friends_by_email
  end

  def after_join_invite_friends_by_fb
    @friends = FbGraph::User.me(current_user.access_token).friends.sort_by(&:name)
  end

  def after_sign_up_invite_friend_by_email
    unless params[:mytags].blank?
      params[:mytags].split(",").each do |email|
        Invite.user_invite_to_swigbig(email, current_user).deliver
      end
      redirect_to users_completion_url, notice: "invite success!"
    else
      redirect_to :back, notice: "undefine email address!"
    end
  end

  def after_sign_up_invite_friend_by_fb
    fb = MiniFB::OAuthSession.new(current_user.access_token)
    params[:fb_ids].each do |fb_id|
      fb.post(fb_id, :type => :feed, :params => {:message => "#{current_user.name} invite you to visit http://swigbig.com/"})
    end
    redirect_to :back, notice: "invite success"
  end

  def mobile_reward
    @user = current_user
    #    @reward = current_user.messages.where(["category = (?) OR category = (?) AND expirate_reward > (?) ", 9, 16, Time.now ]).order("created_at DESC")
    @reward = current_user.messages.where(category: [5, 9, 16, 1]).where(['expirate_reward > ? ', Time.zone.now]).order(:expirate_reward)
    #    @reward_to_expirate = current_user.messages.where(["expirate_reward <= ?", @expirate_within_to_expire.days.from_now])
    @reward_to_expirate = current_user.messages.where(category: [5, 9, 16, 1]).where(["expirate_reward <= ? AND expirate_reward > ?", @expirate_within_to_expire.days.from_now, Time.zone.now]).order(:expirate_reward)
  end

  def facebook_mobile_profile
    @user = current_user
    @top_bar = current_user.swigers.select(:bar_id).group(:bar_id).max.bar.name rescue "Not Swigging Yet!"
    @top_city = current_user.swigers.select(:bar_id).group(:bar_id).max.bar.city rescue "Not Swigging Yet!"
    @total_swig = current_user.swigers.count
    @total_rewards = current_user.messages.where(category: [1, 5, 9, 16])
  end

  def update_user_for_mobile
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end

  def lock_post_event
    message = current_user.update_attributes(lock_fb_post: true) ? "success block reward posting status" : "failed block event status"
    redirect_to :back, notice: message
  end

  def unlock_post_event
    message = current_user.update_attributes(lock_fb_post: false)  ? "success unblock reward posting status" : "failed unblock event status"
    redirect_to :back, notice: message
  end

  def lock_post_to_swigbig_unlock
    message = current_user.update_attributes(fb_post_swig: true)  ? "success block unlock bigswig event status" : "failed block unlock bigswig event status"
    redirect_to :back, notice: message
  end

  def unlock_post_to_swigbig_unlock
    message = current_user.update_attributes(fb_post_swig: false)  ? "success unblock unlock bigswig event status" : "failed unblock unlock bigswig event status"
    redirect_to :back, notice: message
  end

  def sign_out_for_mobile
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    redirect_to redirect_path
  end

  def mobile_invite_friend_by_email
    unless params[:mytags].blank?
      params[:mytags].split(",").each do |email|
        Invite.user_invite_to_swigbig(email, current_user).deliver
      end
      redirect_to users_completion_url, notice: "invite success!"
    else
      redirect_to :back, notice: "undefine email address!"
    end
  end

  def mobile_invite_friends
    @bar = Bar.find(params[:bar_id])
  end

  def convert_facebook_account_to_email_account
    
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    serial = (0...6).collect { chars[Kernel.rand(chars.length)] }.join
    is_existed = true
    while is_existed.eql?(true)
      if RequestUser.where(enter_key: serial).first.nil?
        is_existed = false
      else
        chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
        serial = (0...20).collect { chars[Kernel.rand(chars.length)] }.join
      end
    end

    if current_user.update_attributes(access_token: nil, fb_id: nil, password: serial)
      sign_in current_user, :bypass => true
      Messages.new_email_account_password(current_user, serial).deliver
      redirect_to root_url, notice: "success convert account! Please Check your email to sign in with new password"
    else
      redirect_to :back, notice: "success convert account! Please Check your email to sign in with new password"
    end

  end

  def notify_mark_as_read
    current_user.messages.each do |message|
      message.mark_as_read
    end
    
    @total_notification = current_user.received_messages.where('opened is false').count.to_s
    respond_to :js
  end

  def update_profile
    @user = User.find(current_user.id)
    
    if (Time.now - Chronic.parse(params[:user][:bird_date])) >= 21 and @user.update_attributes(params[:user])
      redirect_to root_url, notice: "Update Success!"
    else
      redirect_to :root, notice: "Can't register under 21 age!"
    end
  end

end

