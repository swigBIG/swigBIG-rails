class Api::V1::SwigMobilesController < ApplicationController
  
  def register 
    @user = User.new(params[:user])
    if @user.save
      render json: {data: "Save Success"}
    else
      render json: {notice: "cannot save user"}
    end
  end
  
  def home
    p params
    
    address = City.get_lat_lang_for_api(params[:user][:city], params[:user][:state], params[:user][:country])
    p "========================================================================="
    p address
    
#    city = City.find_by_name(params[:user][:city])
    city = @city_lat_lng
    # geo = City.find(params[:id])
    loyalty = Loyalty.all
    popularity = Popularity.all
    city_bar = Bar.where(city: city[0])
#    search = Swig.search(params[:user][:city])
    swigs = Swig.where(city: city[0], status: "active", swig_day: Date.today.to_time.in_time_zone.strftime("%A").to_s)
    
    p "========================================================================="
    p city
    p loyalty
    p city_bar
    p swigs
    data_bar = []
    data_city = []
    
        
    swigs.each do |swig|
      data_bar << [swig.deal, swig.people, swig.city, swig.bar.name]
    end
    
    render json: {data: "current user", swigs: data_bar, city: city}
    
  end
  
  
  
end
