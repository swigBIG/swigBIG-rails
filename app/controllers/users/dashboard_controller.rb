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
    @winners = Winner.where(user_id: current_user)
  end

  def rewards
    
  end
end
