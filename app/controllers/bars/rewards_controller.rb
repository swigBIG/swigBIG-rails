class Bars::RewardsController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
    @loyalty = @bar.rewards.where(reward_type: "Loyalty")
    @popularity = @bar.rewards.where(reward_type: "Popularity")
  end
  
end
