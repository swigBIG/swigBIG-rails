class Bars::DashboardController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
    @swig = @bar.swigs.new
    @swigs = @bar.swigs
    @product = @bar.products.new
    @products = @bar.products
  end

  def show
  end

  def create_swig
    @swig = current_bar.swigs.new(params[:swig])
    if @swig.save
      redirect_to :back, notice: "Swig created"
    else
      redirect_to :back, notice: "Swig fail created"
    end
  end

  def update_swig
    @swig = current_bar.swigs.find(params[:id])
    if @swig.update_attributes(params[:swig])
      redirect_to :back, notice: "Swig update"
    else
      redirect_to :back, notice: "Swig fail update"
    end
  end

  def delete_swig
    @swig = Swig.find(params[:id]).destroy
    redirect_to :back, notice: "Swig deleted"
  end

  def active_swig
    @swig = current_bar.swigs.find(params[:id])
    if @swig.update_attributes(status: "active")
      redirect_to :back, notice: "Swig update"
    else
      redirect_to :back, notice: "Swig fail update"
    end
  end

  def deactive_swig
    @swig = current_bar.swigs.find(params[:id])
    if @swig.update_attributes(status: nil)
      redirect_to :back, notice: "Swig update"
    else
      redirect_to :back, notice: "Swig fail update"
    end
  end

  def create_product
    @product = current_bar.products.new(params[:product])
    if @product.save
      redirect_to :back, notice: "product success added"
    else
      redirect_to :back, notice: "product fail added"
    end
  end

  def update_product
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to :back, notice: "product success updated"
    else
      redirect_to :back, notice: "product fail updated"
    end
  end

  def delete_product
    @product = Product.find(params[:id]).destroy
    redirect_to :back, notice: "Swig deleted"
  end
end
