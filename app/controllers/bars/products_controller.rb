class Bars::ProductsController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
    @swig = @bar.swigs.new
    @swigs = @bar.swigs
    @product = @bar.products.new
    @products = @bar.products
  end
  
end
