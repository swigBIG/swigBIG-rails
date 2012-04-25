class Bars::DashboardController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
    @swig = Swig.new
    @swigs = Swig
  end

  def show
  end

  def create_swig
    @swig = Swig.new(params[:swig])
    if @swig.save
      redirect_to :back, notice: "Swig created"
    else
      redirect_to :back, notice: "Swig fail created"
    end
  end

  def update_swig
    @swig = Swig.find(params[:id])
    if @swig.update_attributes(params[:swig])
      redirect_to :back, notice: "Swig update"
    else
      redirect_to :back, notice: "Swig fail update"
    end
  end
end
