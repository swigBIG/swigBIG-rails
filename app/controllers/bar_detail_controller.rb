class BarDetailController < ApplicationController
  layout "bar_profile"
  def show
    @bar = Bar.find(params[:id])
    @swigs = Swig.where(status: "active")
    @swigers = @bar.swigers.all
  end

  def bar_swig
    @bar = Bar.find(params[:b_id])
    @products = @bar.products.all
    @swig = @bar.swigs.find(params[:s_id])
    @swigers = @bar.swigers.all
  end
end
