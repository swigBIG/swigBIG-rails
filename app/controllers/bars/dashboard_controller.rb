class Bars::DashboardController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
  end

  def show
  end
end
