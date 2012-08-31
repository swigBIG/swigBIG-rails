class Bars::GiftsController < ApplicationController

  def destroy
    gift = Gift.find(params[:id])
    gift.destroy
   redirect_to bars_dashboard_url, notice: "Reward delete successfully!"
  end

  def remove_gift
    fewf
  end
end