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
    data_bar = []
    city = @city_lat_lng
    city_bar = Bar.where(city: city[0])
    city_bar.each do |bar|
      data_bar << [bar.name, bar.id, bar.latitude, bar.longitude]
    end

    render json: {bars: data_bar}
  end

  def swigbig_content
    site_content = SiteContent.first
  end
  
  
end
