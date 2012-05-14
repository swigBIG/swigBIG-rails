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
