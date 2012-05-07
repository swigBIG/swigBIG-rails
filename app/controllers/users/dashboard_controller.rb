class Users::DashboardController < ApplicationController
  layout "users"
  
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
    @bars = Bar.all
    @winners = Winner.where(user_id: current_user)
  end
end
