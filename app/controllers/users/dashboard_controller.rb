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
  end
end
