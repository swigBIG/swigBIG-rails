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

  def index

  end

  def city
    @city = City.find(params[:id])
    @loyalty = Loyalty.all
    @popularity = Popularity.all
    if !params[:radius].blank?
      @search = Swig.near(@city.name.to_s, params[:radius], :order => :distance).search(params[:search])
      @swigs = @search.all
    else
      @search = Swig.search(params[:search])
      @swigs = @search.where(city: @city.name.to_s, status: "active", swig_day: Date.today.strftime("%A").to_s)
    end
  end

  def find_by_radius
    if !params[:search].blank?
      @bars = Bar.address.near(params[:search])
    else
      @bars = Bar.all
    end
  end

end


