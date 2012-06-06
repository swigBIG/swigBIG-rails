class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'open-uri'
  before_filter :reject_bot_request, :set_time_zone, :swigbig_content

  def reject_bot_request
    user_agent = request.env['HTTP_USER_AGENT']
    if user_agent.include?('bot') or user_agent.include?('spider')
      render text: 'This is bot request and should be rejected' and return
    end
  end

  def set_time_zone
    #get geo location
    if session["geo_#{set_current_ip}"].blank?
      begin
        geos = Geocoder.search(set_current_ip)
        geo = geos.first
        @city_lat_lng = [geo.data['city'], geo.data['latitude'], geo.data['longitude']]
        session["geo_#{set_current_ip}"] = @city_lat_lng
      rescue
        @city_lat_lng = ["Los Angeles", 34.0863, -118.49]
        session["geo_75.85.54.184"] = @city_lat_lng
      end
      
     
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
    "75.85.54.184"
  end
end
