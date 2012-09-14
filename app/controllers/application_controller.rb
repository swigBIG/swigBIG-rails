class ApplicationController < ActionController::Base
  protect_from_forgery
  require 'open-uri'
  before_filter :reject_bot_request, :swigbig_content, :set_time_zone
  before_filter :set_access_control_headers

  include LogActivityStreams

  def reject_bot_request
    user_agent = request.env['HTTP_USER_AGENT']
    if user_agent.include?('bot') or user_agent.include?('spider')
      render text: 'This is bot request and should be rejected' and return
    end
  end

  def set_time_zone
    if session["geo_#{set_current_ip}"].blank?
      geo = Geokit::Geocoders::MultiGeocoder.geocode(set_current_ip)
      @city_lat_lng = [geo.city, geo.lat, geo.lng]
      session["geo_#{set_current_ip}"] = @city_lat_lng
    else
      @city_lat_lng = session["geo_#{set_current_ip}"]
    end

    if session["offset_#{set_current_ip}"].blank?
      timezone = Timezone::Zone.new(:latlon => [@city_lat_lng[1], @city_lat_lng[2]])
      Time.zone = timezone.zone
    else
      Time.zone = 'Pacific Time (US & Canada)'
    end

  end

  def swigbig_content
    @site_content = SiteContent.first
    @bar_message = ActsAsMessageable::Message.new
    @user_swig_feed = ActivityStream.last
    @loyalty_reward_policy = RewardPolicy.first.loyalty_expirate_date rescue 0
    @popularity_reward_policy = RewardPolicy.first.popularity_expirate_hours rescue 6
  end

  protected

  def set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = "*"
  end

  def set_current_ip
    #    return request.remote_ip.to_s if Rails.env.eql?("development")
    #    "75.85.54.184"
    "64.90.182.55"
    #    '180.246.28.94'
  end

end
