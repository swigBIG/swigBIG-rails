class HomeController < ApplicationController
  def index
    @geo = SimpleGeolocation::Geocoder.new(request.ip.to_s)
    @geo.geocode!
    #    @search = Bar.search(params[:search])
    #    @bars = @search.all
    @search = Swig.search(params[:search])
    if !params[:search].nil?
      @swigs = @search.where(status: "active")
    else
      @swigs = @search.joins("INNER JOIN bars ON swigs.bar_id = bars.id").where(["bars.city = ?", @geo.city])
    end
  end
end
