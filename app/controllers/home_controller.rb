class HomeController < ApplicationController
  def index
    @search = Bar.search(params[:search])
    @bars = @search.all
    @swigs = Swig.where(status: "active")
  end
end
