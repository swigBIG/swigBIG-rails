class HomeController < ApplicationController
  #  layout "home", only: :main
  #  layout "users", only: :index
  layout "users"

  def main
    
    @loyalty = Loyalty.all
    @popularity = Popularity.all
    @city = City.new
    #    @search = Bar.search(params[:search])
    #    @bars = @search.all
    @search = Swig.search(params[:search])
    if !params[:search].nil?
      @swigs = @search.where(status: "active")
    else
      @swigs = @search.joins("INNER JOIN bars ON swigs.bar_id = bars.id").where(["bars.city = ? AND swigs.status = ? ", @city_lat_lng.first, "active"])
    end
  end

  def index;end
  
  def city
    if params[:radius].blank? and params[:search].blank?
      @city = City.find(params[:id])
      @geo = City.find(params[:id])
      @loyalty = Loyalty.all
      @popularity = Popularity.all
      @search = Swig.search(params[:search])
      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Date.today.strftime("%A").to_s)
    elsif !params[:search].blank? or !params[:radius].blank?
      @city = City.find(params[:id])
      @loyalty = Loyalty.all
      @popularity = Popularity.all
      @search = Swig.search(params[:search])
      if !params[:search][:bar_zip_code_contains].blank?
        @geos = Geocoder.search("#{params[:search][:bar_zip_code_contains]},#{@city}")
        @geo = @geos.first
        @swigs = @search.where(city: @city.name.to_s, zip_code: params[:search][:bar_zip_code_contains], status: "active", swig_day: Date.today.to_time.in_time_zone.strftime("%A").to_s)
      elsif !params[:radius].blank?
        @geo = City.find(params[:id])
        @search = Swig.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance).search(params[:search])
        @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Date.today.to_time.in_time_zone.strftime("%A").to_s)
      elsif !params[:search][:bar_zip_code_contains].blank? and !params[:radius].blank?
        @geos = Geocoder.search("#{params[:search][:bar_zip_code_contains]},#{@city}")
        @geo = @geos.first
        @swigs = @search.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance)
      end
    elsif !params[:radius].blank?
      @city = City.find(params[:id])
      @search = Swig.near(@city.name.to_s, params[:radius], :order => :distance).search(params[:search])
      @swigs = @search.all
    else
      @search = Swig.search(params[:search])
      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Date.today.to_time.in_time_zone.strftime("%A").to_s)
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


