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
      fb.post(fb_id, :type => :feed, :params => {:message => "bla bbla"})
    end
    
    redirect_to :back
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
    #    @winners = Winner.where(user_id: current_user)
  end

  def rewards
    @winners = current_user.winners
    @loyalty_points = current_user.points.where(popularity_points: nil).group(:bar_id)
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
end
