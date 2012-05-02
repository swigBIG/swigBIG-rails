class HomeController < ApplicationController
  def index
#    @search = Bar.search(params[:search])
    @search = Swig.search(params[:search])
    @bars = @search.all
    @swigs = @search.where(status: "active")
  end
end
