class ApplicationController < ActionController::Base

  before_filter :set_time_zone
  protect_from_forgery

  def set_time_zone
    unless session[:timezone].blank?
      Time.zone = session[:timezone]
    else
      Time.zone = "Pacific Time (US & Canada)"
    end
  end
  
end
