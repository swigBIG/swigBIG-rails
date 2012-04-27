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
    @swiger = Swiger.new(user_id: current_user.id, bar_id: params[:bar_id])
    if @swiger.save
      redirect_to :back, notice: "You added as Swiger in this BigSwig!"
    else
      redirect_to :back, notice: "You failed added as Swiger in this BigSwig!"
    end
  end
end
