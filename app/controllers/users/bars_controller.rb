class Users::BarsController < ApplicationController
  layout "bar_profile"
  def index
    @bars = Bar.all
    @swigs = Swig
  end

  def show
    @bar = Bar.find(params[:bar_id])
    @swigs = Swig.where(status: "active")
    @swigers = @bar.swigers.all
  end
end
