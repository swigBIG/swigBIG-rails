class HomeController < ApplicationController
  #  layout "home", only: :main
  #  layout "users", only: :index
  layout "users"

  def main
    @city = City.where(name: @city_lat_lng[0].to_s).first
    if params[:radius].blank? and params[:search].blank?
      @geo = City.where(name: @city_lat_lng[0].to_s).first
      @loyalty = Loyalty.all
      @popularity = Popularity.all
      @search = Swig.search(params[:search])
      #      @swigs = @search.where(city: @city_lat_lng[0].to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s)
      @swigs = @search.where(city: @city_lat_lng[0].to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
    elsif !params[:search].blank? or !params[:radius].blank?
      @loyalty = Loyalty.all
      @popularity = Popularity.all
      @search = Swig.search(params[:search])
      debugger
      if !params[:search][:zip_code_contains].blank? and !params[:radius].blank?
        @geos = Geocoder.search("#{params[:search][:zip_code_contains]},#{@city}")
        @geo = @geos.first
        @city_lat_lng = [@city.name, @geo.latitude, @geo.longitude]
        @search = Swig.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance).where(swig_day: Time.zone.now.strftime("%A").to_s).search(params[:search])
        @swigs = @search.page(params[:page]).per(10)
      elsif !params[:search][:zip_code_contains].blank?
        @geos = Geocoder.search("#{params[:search][:zip_code_contains]},#{@city}")
        @geo = @geos.first
        @city_lat_lng = [@city.name, @geo.latitude, @geo.longitude]
        @search = Swig.search(params[:search])
        @swigs = @search.where(city: @city.name.to_s, zip_code: params[:search][:zip_code_contains], status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
      elsif !params[:radius].blank?
        @geo = City.find(params[:id])
        @search = Swig.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance).search(params[:search])
        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
      else
        @geo = City.find(params[:id])
        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
      end
    elsif !params[:radius].blank?
      #      @city = City.find(params[:id])
      @search = Swig.near(@city.name.to_s, params[:radius], :order => :distance).search(params[:search])
      @swigs = @search.page(params[:page]).per(10)
    else
      @search = Swig.search(params[:search])
      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
    end
  end

  def index;end
  
  def city
    swig_bars = Swig.pluck(:bar_id).uniq
    @city = City.find(params[:id])
    if params[:radius].blank? and params[:search].blank?
      @geo = City.find(params[:id])
      @loyalty = Loyalty.all
      @popularity = Popularity.all
      @city_bar = Bar.where(city: @city.name, id: swig_bars)
      @search = Swig.search(params[:search])
      @swigs = @search.where(city: @city.name, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
    elsif !params[:search].blank? or !params[:radius].blank?
      @city_bar = Bar.where(city: @city.name, id: swig_bars)
      #      @city = City.find(params[:id])
      @loyalty = Loyalty.all
      @popularity = Popularity.all
      if !params[:search][:zip_code_contains].blank? and !params[:radius].blank?
        @geos = Geocoder.search("#{params[:search][:zip_code_contains]},#{@city.name}")
        @geo = @geos.first
        @search = Swig.near("#{@geo.data["geometry"]["location"]["lat"]},#{@geo.data["geometry"]["location"]["lng"]}", params[:radius], :order => :distance).where(swig_day: Time.zone.now.strftime("%A").to_s).search(params[:search])
        @swigs = @search.page(params[:page]).per(10)
      elsif !params[:search][:zip_code_contains].blank?
        @geos = Geocoder.search("#{params[:search][:zip_code_contains]},#{@city}")
        @geo = @geos.first
        @search = Swig.search(params[:search])
        @swigs = @search.where(city: @city.name, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
      elsif !params[:radius].blank?
        @geo = City.find(params[:id])
        @search = Swig.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance).search(params[:search])
        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
      else
        @geo = City.find(params[:id])
        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
      end
    elsif !params[:radius].blank?
      @city_bar = Bar.where(city: @city.name, id: swig_bars)
      #      @city = City.find(params[:id])
      @search = Swig.near(@city.name.to_s, params[:radius], :order => :distance).search(params[:search])
      @swigs = @search.page(params[:page]).per(10)
    else
      @city_bar = Bar.where(city: @city.name, id: swig_bars)
      @search = Swig.search(params[:search])
      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Time.zone.now.strftime("%A").to_s).page(params[:page]).per(10)
    end
  end

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

end


