class Users::DashboardController < ApplicationController
  before_filter :authenticate_user!

  layout "users_no_side"
  #  layout "users_view_bar_profile"

  def index
    @user = current_user
    
  end

  def facebook_page
    @top_bar = Swiger.select(:bar_id).group(:bar_id).max
    @swigers = Swiger.where(user_id: current_user).order("created_at DESC")
    @bars = Bar.all
    bar_ids =  Bar.within( @radius_for_swigger, origin: [@city_lat_lng[1], @city_lat_lng[2]]).pluck(:id)
    @friends_swigger = Swiger.today.where(["bar_id IN (?)", bar_ids])
    @user = User.new
    @fb_post = FbGraph::User.me(current_user.access_token).statuses.first.message
    @friends = FbGraph::User.me(current_user.access_token).friends.sort_by(&:name)
    #    @feed = FbGraph::User.me(current_user.access_token).feed!
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
    @top_bar = Swiger.select(:bar_id).group(:bar_id).max
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
    @loyalty_points = current_user.points.where(loyalty_points: 1).group(:bar_id)
    @populrity_points = current_user.points.where(popularity_points: 1).group(:bar_id)
    @rewards = current_user.received_messages.where(coupon_status: false).where(["category = ? OR category = ? OR category = ?", 9, 15, 16]).order("created_at DESC").page(params[:page]).per(5)
    @redeem_rewards = current_user.received_messages.where(coupon_status: true).where(["category = ? OR category = ? OR category = ?", 9, 15, 16]).order("created_at DESC").page(params[:page]).per(5)
    #    @loyalty_points = Bar.loyalty.nil?
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
    @user = current_user
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to :back, notice: "Update Success!"
    else
      redirect_to :back, notice: "Update Failed!"
    end
  end

  def completion
    @user = current_user
  end

  def update_completion
    @user = current_user
    #    if (Time.now.to_date.year - params[:user][:bird_date].to_date.year) >= 21
    if (Time.now.to_date.year - "#{params[:user]["bird_date(3i)"]}-#{params[:user]["bird_date(2i)"]}-#{params[:user]["bird_date(1i)"]}".to_date.year) >= 21
      if @user.update_attributes(avatar: params[:user][:avatar] , phone_number: params[:user][:phone_number] , address: params[:user][:address], zip_code: params[:user][:zip_code], city: params[:user][:city], state: params[:user][:state], bird_date: "#{params[:user]["bird_date(3i)"]}-#{params[:user]["bird_date(2i)"]}-#{params[:user]["bird_date(1i)"]}".to_date )
        sign_in @user, :bypass => true
        redirect_to root_path, notice: "Profile Completion Success!"
      else
        redirect_to :back, notice: "Profile Completion Failed!"
      end
    else
      @user.destroy
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
    @reward = current_user.messages.where(["category = (?) OR category = (?)", 9, 16]).order("created_at DESC")
  end

end

