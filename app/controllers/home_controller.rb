class HomeController < ApplicationController

  def index
    @geo = SimpleGeolocation::Geocoder.new(set_current_ip)
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
  
  protected
  
  def set_current_ip
    return request.ip.to_s if Rails.env.eql?("production")
    "125.163.30.11"
  end

end


