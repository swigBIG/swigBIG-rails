class Users::BarsController < ApplicationController
  layout "users_view_bar_profile"
  
  def index
    @bars = Bar.all
    @swigs = Swig
  end

  def show
    @bar = Bar.find(params[:bar_id])
    @bar_name = @bar.name
    @swigs = @bar.swigs#.where(status: "active")
    @total_swiggers = @bar.swigers.count
    @swigers = @bar.swigers.today.limit(6) rescue nil
    @popularity = @bar.popularity
    @loyalty = @bar.loyalty
    @bar_hours = @bar.bar_hours
    @monday_hour = @bar.bar_hours.where(day: "Monday")
    @tuesday_hour = @bar.bar_hours.where(day: "Tuesday")
    @wednesday_hour = @bar.bar_hours.where(day: "Wednesday")
    @thurday_hour = @bar.bar_hours.where(day: "Thursday")
    @friday_hour = @bar.bar_hours.where(day: "Friday")
    @saturday_hour = @bar.bar_hours.where(day: "Saturday")
    @sunday_hour = @bar.bar_hours.where(day: "Sunday")
    if user_signed_in?
      #      @friends = current_user.friends
      unless current_user.fb_id.blank?
        @friends = FbGraph::User.me(current_user.access_token).friends.sort_by(&:name)
      end
    else
      @friends = []
    end
    if @bar.popularity.blank? and user_signed_in?
      @inviter = @bar.popularity_inviters.new
    else
      @inviter = []
    end
    respond_to do |format|
      format.html
      format.mobile
    end
  end

  def create_popularity
    @bar = Bar.find(params[:bar_id])
    @popularity_inviter = @bar.popularity_inviters.new(user_id: current_user.id, users_inviters_id: params[:guess_ids].join(",") )
    if @popularity_inviter.save
      if  !params[:guess_ids].blank?
        @popularity_inviter.popularity_guesses.create(user_id: current_user.id, bar_id: @popularity_inviter.bar_id)
        params[:guess_ids].each do |guess_id|
          @popularity_inviter.popularity_guesses.create(user_id: guess_id, bar_id: @popularity_inviter.bar_id)
        end
        redirect_to :back, notice: "Success Create Popularity!"
      else
        @popularity_inviter.destroy
        redirect_to :back, notice: "Empty Guess!"
      end
    else
      redirect_to :back, notice: "Fail Create Popularity!"
    end
  end

  def redeem_reward
    coupon = Bar.find(params[:bar_id]).winners.where(coupon: params[:coupon]).first
    unless coupon.blank?
      user_coupon = current_user.messages.where(coupon: params[:coupon]).first
      coupon.update_attributes(coupon_status: 1)
      user_coupon.update_attributes(coupon_status: 1)
      redirect_to :back, notice: "success claim reward"
    else
      redirect_to :back, notice: "failed claim reward! unregistered coupon!"
    end
  end

  def swiger_list
    @bar = Bar.find(params[:bar_id])
    #    @swigers = @bar.swigers.order("created_at DESC")
    @swigers = @bar.swigers.today.order("created_at DESC")
  end

  def profile
    @bar = Bar.find(params[:bar_id])
    @standard_swigs = @bar.swigs.standard
    @big_swigs = @bar.swigs.big
    @total_swiggers = @bar.swigers.count
    @swigers = @bar.swigers.today.limit(6) rescue nil
    @popularity = @bar.popularity
    @loyalty = @bar.loyalty
    @monday_hour = @bar.bar_hours.where(day: "Monday")
    @tuesday_hour = @bar.bar_hours.where(day: "Tuesday")
    @wednesday_hour = @bar.bar_hours.where(day: "Wednesday")
    @thurday_hour = @bar.bar_hours.where(day: "Thursday")
    @friday_hour = @bar.bar_hours.where(day: "Friday")
    @saturday_hour = @bar.bar_hours.where(day: "Saturday")
    @sunday_hour = @bar.bar_hours.where(day: "Sunday")
    respond_to do |format|
      format.html
      format.mobile
    end
  end

  #  def create_popularity
  #    @bar = Bar.find(params[:bar_id])
  #    if !params[:guess_ids].blank?
  #      @popularity_inviter = @bar.popularity_inviters.new(user_id: current_user.id, users_inviters_id: params[:guess_ids].join(",") )
  #      if @popularity_inviter.save
  #        redirect_to :back, notice: "Popularity Success created!"
  #      else
  #        redirect_to :back, notice: "Popularity Failed created!"
  #      end
  #    else
  #      redirect_to :back, notice: "Empty Guess! Please check your swig friends!"
  #    end
  #  end

  
end
