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

    if user_signed_in?
      @swiger = @bar.swigers.new(user_id: current_user.id)

      if @swiger.save
        if !@bar.loyalty.blank?
          @point = current_user.points.new(bar_id: @bar.id, loyalty_points: 1 )

          if @point.save
            redirect_to :back, notice: "You added as Swiger in this BigSwig!"
          else
            redirect_to :back, notice: "You failed added as Swiger in this BigSwig!"
          end
        else
          redirect_to :back, notice: "You added as Swiger in this BigSwig!"
        end
      else
        redirect_to :back, notice: @swiger.errors["time and distance"].first
      end
    else
      redirect_to :back, notice: "You must sign in first!"
    end
  end

end
