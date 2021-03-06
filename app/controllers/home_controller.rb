class HomeController < ApplicationController
  layout "users"

  before_filter :redirect_to_request_invitation_page

  def redirect_to_request_invitation_page
    unless session[:request_user_privilage] or is_mobile_request?
      redirect_to invitations_request_url
    else
      return
    end
  end

  def index; end

  def get_latitude_and_longitude_from_mobile
    data = User.find_by_email(params[:user][:email])
  end

  def main
    @city = City.where(name: @city_lat_lng[0].to_s).first

    if user_signed_in?
      if current_user.access_token
        fb_ids = FbGraph::User.me(current_user.access_token).friends.map(&:identifier)
        fb_friends_ids = User.where(fb_id: fb_ids).pluck(:fb_id)
        @friends_swigger = Swiger.joins(:user).where(["users.fb_id IN (?) AND swigers.created_at >= (?) AND swigers.created_at <= (?)", fb_friends_ids,( Time.zone.now - @swigger_show_within.hours ), Time.zone.now ])
      end
    end

    conditions = []
    conditions << "bars.address IS NOT NULL "
    conditions << "swigs.swig_type = '#{params[:swig_type]}'" unless params[:swig_type].blank?
    conditions << "bars.sports_team LIKE '%#{params[:sports_team]}%'" unless params[:sports_team].blank?
    conditions << "swigs.swig_day = '#{Time.zone.now.strftime("%A").to_s}'"

    @origin = params[:zip_code].blank? ? [@city_lat_lng[1], @city_lat_lng[2]] : params[:zip_code]
    
    unless params[:radius].blank?
      @bars = Bar.within(params[:radius].to_i, origin: @origin).includes(:swigs).where(conditions.join(" AND ")).order("swig_type DESC")
    else
      if is_mobile_request?
        unless session[:after_redirect]
          session[:homepage_request_page] = true
        end

        @bars = Bar.within(@radius_to_show_in_mobile_list ,origin: @origin).includes(:swigs).where(conditions.join(" AND ")).sort_by_distance_from(@origin)#.take(5)
      else
        @bars = Bar.within(@radius_to_show_in_mobile_list ,origin: @origin).includes(:swigs).where(conditions.join(" AND ")).sort_by_distance_from(@origin)
      end
    end
    
    unless params[:zip_code].blank?
      geo = Geocoder.search("#{params[:zip_code]},#{@city.name}").first
      @city_lat_lng = [geo.data['city'], geo.data['latitude'], geo.data['longitude']]
      @bars = Bar.geo_scope(origin: @origin).includes(:swigs).where(conditions.join(" AND ")).where(zip_code: params[:zip_code])
    end

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def city
    @city = City.find(params[:id])

    conditions = []
    conditions << "swigs.swig_type = '#{params[:swig_type]}'" unless params[:swig_type].blank?
    conditions << "bars.sports_team LIKE '%#{params[:sports_team]}%'" unless params[:sports_team].blank?
    conditions << "swigs.swig_day = '#{Time.zone.now.strftime("%A").to_s}'"

    @origin = params[:zip_code].blank? ? [@city.latitude, @city.longitude] : params[:zip_code]

    unless params[:radius].blank?
      @bars = Bar.within(params[:radius].to_i, origin: @origin).includes(:swigs).where(conditions.join(" AND ")).where(city: @city.name).order("swig_type DESC")
    else
      @bars = Bar.geo_scope(origin: @origin).includes(:swigs).where(conditions.join(" AND ")).where(city: @city.name).order("swig_type DESC")
    end

    unless params[:zip_code].blank?
      geo = Geocoder.search("#{params[:zip_code]},#{@city.name}").first
      @city_lat_lng = [geo.data['city'], geo.data['latitude'], geo.data['longitude']]
      @bars = Bar.geo_scope(origin: @origin).includes(:swigs).where(conditions.join(" AND ")).where(zip_code: params[:zip_code]).order("swig_type DESC")
    end
  end

  def contact_us
    @new_contact = Contact.new
  end

  def contact_us_for_homepage
    @new_contact = Contact.new
  end

  def create_contact_us
    @new_contact = Contact.new(params[:contact])

    if @new_contact.save
      redirect_to :back, notice: "send contact success"
    else
      redirect_to :back, notice: "send contact fail"
    end
  end

  def bars_list_to_swig
    conditions = ["swigs.swig_day = '#{Time.zone.now.strftime("%A").to_s}'"]

    @bars = Bar.within(@valid_radius_for_swigging, origin: [@city_lat_lng[1], @city_lat_lng[2]], order: "distance DESC").
      includes(:swigs).where(conditions.join(" AND ")).sort_by_distance_from([@city_lat_lng[1], @city_lat_lng[2]])
    
  end

  def mobile_dashboard; end

  def sign_out_turning_point; end

end