class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  include LogActivityStreams

  protect_from_forgery
  require 'open-uri'

  mobylette_config do |config|
    config[:fallback_chains] = { mobile: [:mobile, :html] }
    config[:skip_xhr_requests] = false
  end

  before_filter :reject_bot_request, :swigbig_content, :set_time_zone
  before_filter :set_access_control_headers

  def reject_bot_request
    user_agent = request.env['HTTP_USER_AGENT']
    if user_agent.include?('bot') or user_agent.include?('spider')
      render text: 'This is bot request and should be rejected' and return
    end
  end

  def set_time_zone
    if request.xhr? and !params[:geo].blank?
      geo = Geokit::Geocoders::MultiGeocoder.geocode("#{params[:geo][:mobile_lat]},#{params[:geo][:mobile_lng]}")
      @city_lat_lng = [geo.city, params[:geo][:mobile_lat], params[:geo][:mobile_lng]]
      session["geo_#{set_current_ip}"] = @city_lat_lng
      
    else
      if session["geo_#{set_current_ip}"].blank?
        geo = Geokit::Geocoders::MultiGeocoder.geocode(set_current_ip)
        @city_lat_lng = [geo.city, geo.lat, geo.lng]
        session["geo_#{set_current_ip}"] = @city_lat_lng
      else
        @city_lat_lng = session["geo_#{set_current_ip}"]
      end
    end

    if @city_lat_lng
      timezone = Timezone::Zone.new(:latlon => [@city_lat_lng[1], @city_lat_lng[2]]) rescue nil
      Time.zone = timezone.zone rescue nil
    else
      Time.zone = 'Pacific Time (US & Canada)'
    end

    if request.xhr? and !params[:geo].blank?
      #      if params[:controller] == 'home' and params[:action] == 'main'
      #        render "home/redirect_with_js"
      #      else
      if session[:homepage_request_page].eql?(true)
        session[:homepage_request_page] = false
        render "home/redirect_with_js"
      else
        render :nothing => true
      end
    end
    
    #    if session["offset_#{set_current_ip}"].blank?
    #      timezone = Timezone::Zone.new(:latlon => [@city_lat_lng[1], @city_lat_lng[2]])
    #      Time.zone = timezone.zone
    #    else
    #      if request.xhr?
    #        timezone = Timezone::Zone.new(:latlon => [@city_lat_lng[1], @city_lat_lng[2]])
    #        Time.zone = timezone.zone
    #      else
    #        Time.zone = 'Pacific Time (US & Canada)'
    #      end
    #    end
  end

  def swigbig_content
    @site_content = SiteContent.first
    @bar_message = ActsAsMessageable::Message.new
    @user_swig_feed = ActivityStream.last
    @test = request.remote_ip
    @radius_for_swigger = RadiusSwigger.first.radius rescue 100
    @loyalty_reward_policy = RewardPolicy.first.loyalty_expirate_date rescue 10
    @popularity_reward_policy = RewardPolicy.first.popularity_expirate_hours rescue 6
    @expirate_within_to_expire = RewardPolicy.first.expirate_within rescue 10
    @valid_radius_for_swigging = RadiusSwigging.first.radius rescue 1
    @radius_to_show_in_mobile_list = RadiusToShowBarInMobile.first.radius rescue 10
    @swigger_show_within = FbSwiggerHour.blank? ? FbSwiggerHour.first : 6
  end

  protected

  def set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = "*"
  end

  def set_current_ip
    return request.remote_ip.to_s if Rails.env.eql?("development")
    #    "75.85.54.184"
    #    "64.90.182.55"
    #        '180.246.28.94'
    #    '75.85.48.139'
  end

end
