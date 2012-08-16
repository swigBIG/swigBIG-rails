class Api::V1::SwigMobilesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :reject_bot_request, :swigbig_content, :set_time_zone
  before_filter :set_access_control_headers

  def register
    user = User.new(params[:user])
    if user.save
      render json: {data: "Save Success", user_id: user.id}
    else
      render json: {notice: "cannot save user"}
    end
  end

  def update_user
    user = User.where("id = ?", params[:id])

    if !user.blank?
      user.first.update_attributes(name: params[:name], bird_date: params[:bird_date])
      render json: {data: "Save Success", name: user.name}
    else
      render json: {notice: "User not found"}
    end
  end

  def swigbig_mobile
    @geo = City.where("longitude = ? AND latitude = ?", params[:lon], params[:lat]).first
    @city_bar = @geo.blank? ? [] : Bar.where(city: @geo.name)

    session[:using_mobile] = true
    render :layout => false
  end

  def home
    #    ip = return request.ip.to_s if Rails.env.eql?("development")
    ip = "64.90.182.55"
    data_bars = []
    #    city_bars = Bar.near("#{geo.data['latitude']},#{geo.data['longitude']}", 25, order: :distance)
    #    city_bars = Bar.near("40.7089, -74.0012", 25, order: :distance)
    city_bars = Bar.geo_scope(origin: "40.7089, -74.0012")
    city_bars.each do |bar|
      distance = sprintf("%0.02f", bar.distance_from([40.7089,-74.0012]))
      data_bars << [bar.name, bar.id, bar.latitude, bar.longitude, "#{distance} mi", bar.id]
    end
    render json: {bars: data_bars}
  end

  def bar_swigs
    bar = Bar.find(params[:bar_id])
    bar_name = bar.name
    data_swig = []
    bar.swigs.big.today.each do |swig|
      data_swig << [swig.id, swig.deal, swig.people, swig.lock_status]
    end
    render text: "{\"swigs\":#{data_swig.to_json}, \"bar_name\":\"#{bar_name}\"}"
  end

  def bar_in_city
    Bar.near("#{@geo.latitude},#{@geo.longitude}", params[:radius], :order => :distance).search(params[:search])
  end

  def swigbig_content
    site_content = SiteContent.first.logos.where(active_status: true).first
    render :text => open(site_content.image_url, "rb").read
  end

  def get_map
    @geo = City.where("name = ?", 'new york').first
    @city_bar = Bar.where(city: @geo.name)

    render layout: false
  end

  def swig_list
    render layout: false
  end

  def swig_bar
    bar = Bar.find(params[:bar_id])
    user = User.find(params[:user_id])
    swiger = bar.swigers.new(user_id: user.id)
    if swiger.save
      if !bar.loyalty.blank?
        point = user.points.new(bar_id: bar.id, loyalty_points: 1 )
        if point.save
          text = "Thank you for Swigging!"
          render json: {text: text}
        else
          text = "You failed added as Swiger in this BigSwig!"
          render json: {text: text}
        end
      else
        text = "Thank you for Swigging!"
        render json: {text: text}
      end
    else
      text = "#{swiger.errors["time and distance"].first} #{swiger.errors["time and distance"].first}"
      render json: {text: text}
    end
  end


  private

  def set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = "*"
  end
end