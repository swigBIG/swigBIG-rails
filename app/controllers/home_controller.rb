class HomeController < ApplicationController
  def index
    @geo = SimpleGeolocation::Geocoder.new(request.ip.to_s)
    @geo.geocode!

#    @search = Bar.search(params[:search])
    @search = Swig.search(params[:search])
    @bars = @search.all
    @swigs = @search.where(status: "active")
  end
end
