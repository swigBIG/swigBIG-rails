class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'open-uri'
  before_filter :set_time_zone, :swigbig_content

  def set_time_zone
    #get geo location
    if session["geo_#{set_current_ip}"].blank?
      begin
        geos = Geocoder.search(set_current_ip)
      rescue
        geos = Geocoder.search("75.85.54.184")
      end
      geo = geos.first
      @city_lat_lng = [geo.data['city'], geo.data['latitude'], geo.data['longitude']]
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
    #   return request.ip.to_s if Rails.env.eql?("development")
    "75.85.54.184"
  end
end
