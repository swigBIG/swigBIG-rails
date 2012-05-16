class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_time_zone, :swigbig_content, :get_bars_subdomain

  def set_time_zone
    unless session[:timezone].blank?
      Time.zone = session[:timezone]
    else
      Time.zone = "Pacific Time (US & Canada)"
    end
  end

  def swigbig_content
    @site_content = SiteContent.first
  end

  def get_bars_subdomain
    p "000000000000000"
    Subdomain.matches?(request)
  end
  
end
