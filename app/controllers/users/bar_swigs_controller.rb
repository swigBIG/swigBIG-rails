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
    if !@bar.loyalty.blank?
      #      @point = Point.where(user_id: current_user.id, bar_id: @bar.id).first
      #      Point.find_or_created(id: @point.id)
      if user_signed_in?
        @create_point = current_user.points.new(bar_id: @bar.id, loyalty_points: 1 )
        @swiger = Swiger.create(user_id: current_user.id, bar_id: @bar.id)
        #        @create_point = Point.new(bar_id: @bar.id, user_id: current_user.id, loyalty_points: 1 )
        if @create_point.save
          redirect_to :back, notice: "You added as Swiger in this BigSwig!"
        else
          redirect_to :back, notice: "You added as Swiger in this BigSwig!"
        end
      else
        redirect_to :back, notice: "You added as Swiger in this BigSwig!"
      end
    else
      @swiger = Swiger.new(user_id: current_user.id, bar_id: @bar.id)
      if @swiger.save
        redirect_to :back, notice: "You added as Swiger in this BigSwig!"
      else
        redirect_to :back, notice: "You failed added as Swiger in this BigSwig!"
      end
    end

  end
end
