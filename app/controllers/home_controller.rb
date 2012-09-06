class HomeController < ApplicationController
  #  layout "home", only: :main
  #  layout "users", only: :index
  layout "users"

  def main
    #    begin
    @city = City.where(name: @city_lat_lng[0].to_s).first
    conditions = []
    conditions << "swigs.swig_type = '#{params[:swig_type]}'" unless params[:swig_type].blank?
    conditions << "swigs.swig_day = '#{Time.zone.now.strftime("%A").to_s}'"
    conditions << "bars.sports_team = '#{params[:sports_team]}'" unless params[:sports_team].blank?
    @origin = params[:zip_code].blank? ? [@city_lat_lng[1], @city_lat_lng[2]] : params[:zip_code]
    unless params[:radius].blank?
      @bars = Bar.within(params[:radius].to_i, origin: @origin).includes(:swigs).where(conditions.join(" AND "))
    else
      @bars = Bar.geo_scope(origin: @origin).includes(:swigs).where(conditions.join(" AND "))
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

  def index;end

  #  def city
  #    swig_bars = Swig.pluck(:bar_id).uniq
  #    @city = City.find(params[:id])
  #    if params[:radius].blank? and params[:search].blank?
  #      @geo = City.find(params[:id])
  #      @loyalty = Loyalty.all
  #      @popularity = Popularity.all
  #      @city_bar = Bar.where(city: @city.name, id: swig_bars)
  #      @search = Swig.search(params[:search])
  #      @swigs = @search.where(city: @city.name, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
  #    elsif !params[:search].blank? or !params[:radius].blank?
  #      @city_bar = Bar.where(city: @city.name, id: swig_bars)
  #      #      @city = City.find(params[:id])
  #      @loyalty = Loyalty.all
  #      @popularity = Popularity.all
  #      if !params[:search][:zip_code_contains].blank? and !params[:radius].blank?
  #        @geos = Geocoder.search("#{params[:search][:zip_code_contains]},#{@city.name}")
  #        @geo = @geos.first
  #        @search = Swig.near("#{@geo.data["geometry"]["location"]["lat"]},#{@geo.data["geometry"]["location"]["lng"]}", params[:radius], :order => :distance).where(swig_day: Time.zone.now.strftime("%A").to_s).search(params[:search])
  #        @swigs = @search.page(params[:page]).per(10)
  #      elsif !params[:search][:zip_code_contains].blank?
  #        @geos = Geocoder.search("#{params[:search][:zip_code_contains]},#{@city}")
  #        @geo = @geos.first
  #        @search = Swig.search(params[:search])
  #        @swigs = @search.where(city: @city.name, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
  #      elsif !params[:radius].blank?
  #        @geo = City.find(params[:id])
  #        @search = Swig.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance).search(params[:search])
  #        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
  #      else
  #        @geo = City.find(params[:id])
  #        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
  #      end
  #    elsif !params[:radius].blank?
  #      @city_bar = Bar.where(city: @city.name, id: swig_bars)
  #      #      @city = City.find(params[:id])
  #      @search = Swig.near(@city.name.to_s, params[:radius], :order => :distance).search(params[:search])
  #      @swigs = @search.page(params[:page]).per(10)
  #    else
  #      @city_bar = Bar.where(city: @city.name, id: swig_bars)
  #      @search = Swig.search(params[:search])
  #      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
  #    end
  #  end

  #  def city
  #    @city = City.find(params[:id])
  #    @loyalty = Loyalty.all
  #    @popularity = Popularity.all
  #    if !params[:radius].blank?
  #      @search = Swig.near(@city.name.to_s, params[:radius], :order => :distance).search(params[:search])
  #      @swigs = @search.all
  #    else
  #      @search = Swig.search(params[:search])
  #      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Date.today.strftime("%A").to_s)
  #    end
  #  end

  def find_by_radius
    if !params[:search].blank?
      @bars = Bar.address.near(params[:search])
    else
      @bars = Bar.all
    end
  end

  def live_swig_feed
    @user_swig_feed = Swiger.last
    render layout: false
  end

end


