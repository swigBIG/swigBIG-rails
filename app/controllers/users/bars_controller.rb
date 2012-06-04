class Users::BarsController < ApplicationController
  layout "users"
  
  def index
    @bars = Bar.all
    @swigs = Swig
  end

  def show
    @bar = Bar.find(params[:bar_id])
    @bar_name = @bar.name
    @swigs = @bar.swigs.where(status: "active")
    @swigers = @bar.swigers.all
    @popularity = Popularity.where(bar_id: @bar)
    @loyalty = Loyalty.where(bar_id: @bar)
    @bar_hours = @bar.bar_hours
    @monday_hour = @bar.bar_hours.where(day: "Monday")
    @tuesday_hour = @bar.bar_hours.where(day: "Tuesday")
    @wednesday_hour = @bar.bar_hours.where(day: "Wednesday")
    @thurday_hour = @bar.bar_hours.where(day: "Thursday")
    @friday_hour = @bar.bar_hours.where(day: "Friday")
    @saturday_hour = @bar.bar_hours.where(day: "Saturday")
    @sunday_hour = @bar.bar_hours.where(day: "Sunday")
    if user_signed_in?
      @friends = current_user.friends
    else
      @friends = []
    end
    if @bar.popularity.blank? and user_signed_in?
      @inviter = @bar.popularity_inviters.new
    else
      @inviter = []
    end
  end

  def create_popularity
    @bar = Bar.find(params[:bar_id])
    @popularity_inviter = @bar.popularity_inviters.new(user_id: current_user.id)
    if @popularity_inviter.save
      params[:guess_ids].each do |guess_id|
        @popularity_inviter.popularity_guesses.create(user_id: guess_id)
      end
      redirect_to :back, notice: "Success Create Popularity!"
    else
      redirect_to :back, notice: "Fail Create Popularity!"
    end
  end
end
