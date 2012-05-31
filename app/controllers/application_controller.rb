class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'open-uri'
  before_filter :set_time_zone, :swigbig_content

  def set_time_zone
    #get geo location
    if session["geo_#{set_current_ip}"].blank?
      geo = SimpleGeolocation::Geocoder.new(set_current_ip)
      geo.geocode!
      @city_lat_lng = [geo.city, geo.lat, geo.lng]
      session["geo_#{set_current_ip}"] = @city_lat_lng
    else
      @city_lat_lng = session["geo_#{set_current_ip}"]
    end

    #get timezone
    if session["offset_#{set_current_ip}"].blank?
      url = URI.parse("http://www.earthtools.org/timezone-1.1/#{@city_lat_lng[1]}/#{@city_lat_lng[2]}")
      xml_content = url.open.read
      offset = xml_content.scan(/<offset>(.*?)<\/offset>/).first.first rescue nil
      session["offset_#{set_current_ip}"] = offset
    else
      offset = session["offset_#{set_current_ip}"]
    end
    
    if offset.blank?
      Time.zone = 'Pacific Time (US & Canada)'
    else
      timezone = ActiveSupport::TimeZone[(offset.to_i)*60*60].name
      Time.zone = timezone  
    end
    
  end

  def swigbig_content
    @site_content = SiteContent.first
  end

  protected

  def set_current_ip
    return request.ip.to_s if Rails.env.eql?("development")
    "125.163.30.11"
  end
end
