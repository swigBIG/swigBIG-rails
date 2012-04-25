class Users::DashboardController < ApplicationController
  layout "users"
  
  def index
    @user = current_user
    unless Bar.blank?
      @bars = Bar.all
    else
      @bars = []
    end
  end

  def show
  end
end
