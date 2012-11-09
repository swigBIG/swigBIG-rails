class BarHomeController < ApplicationController
  layout "main_bars"

  def index
    if bar_signed_in?
      redirect_to bars_dashboard_url
    end
  end
  
end
