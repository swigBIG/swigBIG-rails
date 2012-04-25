class Users::BarsController < ApplicationController
  layout "users"
  def index
    @bars = Bar.all
  end

  def show
    @bar = Bar.find(params[:bar_id])
  end
end
