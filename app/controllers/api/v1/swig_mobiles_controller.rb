class Api::V1::SwigMobilesController < ApplicationController
  skip_before_filter :reject_bot_request, :swigbig_content
  
  def register 
    user = User.new(params[:user])
    if user.save
      render json: {data: "Save Success"}
    else
      render json: {notice: "cannot save user"}
    end
  end
  
  def home
#    address = City.get_lat_lang_for_api(params[:user][:city], params[:user][:state], params[:user][:country])
    
    city = @city_lat_lng
#    loyalty = Loyalty.all
#    popularity = Popularity.all
#    city_bar = Bar.where(city: city[0])
    swigs = Swig.where(city: city[0], status: "active", swig_day: Date.today.to_time.in_time_zone.strftime("%A").to_s)
    

    data_bar = []
#    data_city = []
    
        
    swigs.each do |swig|
      data_bar << [swig.deal, swig.people, swig.city, swig.bar.name]
    end
    
    render json: {data: "current user", swigs: data_bar, city: city}
    
  end
  
  
  
end
