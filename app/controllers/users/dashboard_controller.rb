class Users::DashboardController < ApplicationController
  before_filter :authenticate_user!

  #  layout "users", only: :index
  layout "users_no_side"
  #  layout "users_no_side", only: [:rewards, :show]


  def index
    @user = current_user
    unless Bar.blank?
      @bars = Bar.all
    else
      @bars = []
    end
    @swigs = Swig.where(status: "active")
  end
  def facebook_page
    @top_bar = Swiger.select(:bar_id).group(:bar_id).max
    @swigers = Swiger.where(user_id: current_user).order("created_at DESC")
    @bars = Bar.all
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

  def invite_swigbig
    fb = MiniFB::OAuthSession.new(current_user.access_token)

    params[:fb_ids].each do |fb_id|
      fb.post(fb_id, :type => :feed, :params => {:message => "#{current_user.name} invite you to visit swigbig.com"})
    end
    
    redirect_to :back, notice: "invite success"
  end

  def invite_by_email
    params[:emails_address].each do |e|
      Invite.send_invite_email(e, current_user).deliver
    end

    redirect_to :back, notice: "invite has been sent"
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
    #    @winners = Winner.where(user_id: current_user)
  end

  def rewards
    @winners = current_user.winners
    @loyalty_points = current_user.points.where(popularity_points: nil).group(:bar_id)
    @gifts = current_user.received_messages.pluck(:gift_id).compact
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
    if (Time.now.to_date.year - params[:user][:bird_date].to_date.year) >= 21
      if @user.update_attributes(params[:user])
        sign_in @user, :bypass => true
        redirect_to users_dashboard_path, notice: "Profile Completion Success!"
      else
        redirect_to :back, notice: "Profile Completion Failed!"
      end
    else
      @user.destroy
      redirect_to :root, notice: "Age under 21 can't register!"
    end
  end

end
