class Users::BarSwigsController < ApplicationController
  layout "bar_profile"
  def index

  end

  def show_swig
    @bar = Bar.find(params[:bar_id])
    @products = @bar.products.all
    @swig = @bar.swigs.find(params[:swig_id])
  end

  def enter_bar
    @bar = Bar.find(params[:bar_id])
    if !@bar.rewards.where(reward_type: "Loyalty").blank?
#      @point = Point.where(user_id: current_user.id, bar_id: @bar.id).first
#      Point.find_or_created(id: @point.id)
      current_user.points.create(bar_id: @bar.id, loyalty_points: 1 )
    end
    @swiger = Swiger.new(user_id: current_user.id, bar_id: params[:bar_id])

    if @swiger.save
      redirect_to :back, notice: "You added as Swiger in this BigSwig!"
    else
      redirect_to :back, notice: "You failed added as Swiger in this BigSwig!"
    end
  end
end
