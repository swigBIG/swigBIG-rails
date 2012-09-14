class HomeController < ApplicationController
  layout "users"

  def index;end

  def main
    @city = City.where(name: @city_lat_lng[0].to_s).first
    conditions = []
    conditions << "swigs.swig_type = '#{params[:swig_type]}'" unless params[:swig_type].blank?
    conditions << "swigs.swig_day = '#{Time.zone.now.strftime("%A").to_s}'"
    conditions << "bars.sports_team = '#{params[:sports_team]}'" unless params[:sports_team].blank?
    @origin = params[:zip_code].blank? ? [@city_lat_lng[1], @city_lat_lng[2]] : params[:zip_code]
    unless params[:radius].blank?
      @bars = Bar.within(params[:radius].to_i, origin: @origin).includes(:swigs).where(conditions.join(" AND "))
    else
      #      @bars = Bar.geo_scope(origin: @origin).includes(:swigs).where(conditions.join(" AND "))
      @bars = Bar.within(25, origin: @origin).includes(:swigs).where(conditions.join(" AND "))
    end
    unless params[:zip_code].blank?
      geo = Geocoder.search("#{params[:zip_code]},#{@city.name}").first
      @city_lat_lng = [geo.data['city'], geo.data['latitude'], geo.data['longitude']]
    end
  end

  def city
    @city = City.find(params[:id])
    conditions = []
    conditions << "swigs.swig_type = '#{params[:swig_type]}'" unless params[:swig_type].blank?
    conditions << "swigs.swig_day = '#{Time.zone.now.strftime("%A").to_s}'"
    conditions << "bars.sports_team = '#{params[:sports_team]}'" unless params[:sports_team].blank?
    @origin = params[:zip_code].blank? ? [@city.latitude, @city.longitude] : params[:zip_code]
    unless params[:radius].blank?
      @bars = Bar.within(params[:radius].to_i, origin: @origin).includes(:swigs).where(conditions.join(" AND ")).where(city: @city.name)
    else
      @bars = Bar.geo_scope(origin: @origin).includes(:swigs).where(conditions.join(" AND ")).where(city: @city.name)
    end
    unless params[:zip_code].blank?
      geo = Geocoder.search("#{params[:zip_code]},#{@city.name}").first
      @city_lat_lng = [geo.data['city'], geo.data['latitude'], geo.data['longitude']]
    end
  end

  def live_swig_feed
    render layout: false
  end

end


