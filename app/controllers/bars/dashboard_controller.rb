class Bars::DashboardController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
    @swigers = @bar.swigers
    @swig = @bar.swigs.new
    @swigs = @bar.swigs
#    @reward = @bar.rewards.new
    @reward = []
    @loyal = Loyalty.new
    @popular = Popularity.new
#    @popularity = @bar.rewards.where(reward_type: "Popularity")
    @popularity = Popularity.all
#    @loyalty = @bar.rewards.where(reward_type: "Loyalty")
    @loyalty = Loyalty.all
    @winner = @bar.winners.all
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

#  def create_reward
#    @reward = current_bar.rewards.new(params[:reward])
#    if @reward.save
#      redirect_to :back, notice: "reward success added"
#    else
#      redirect_to :back, notice: "reward fail added"
#    end
#  end

  def create_loyalty
    @loyalty = Loyalty.new(params[:loyalty])
    
    if @loyalty.save
#      Loyalty.find().update_attributes(bar_id: current_bar.id)
      redirect_to :back, notice: "loyalty success added"
    else
      redirect_to :back, notice: "loyalty fail added"
    end
  end
  
  def create_popularity
    @popularity = Popularity.new(params[:popularity])
    if @popularity.save
      redirect_to :back, notice: "popularity success added"
    else
      redirect_to :back, notice: "popularity fail added"
    end
  end

#  def update_reward
#    @reward = Reward.find(params[:id])
#    if @reward.update_attributes(params[:reward])
#      redirect_to :back, notice: "reward success updated"
#    else
#      redirect_to :back, notice: "reward fail updated"
#    end
#  end
  def update_loyalty
    @loyalty = Loyalty.find(params[:id])
    if @loyalty.update_attributes(params[:loyalty])
      redirect_to :back, notice: "loyalty success updated"
    else
      redirect_to :back, notice: "loyalty fail updated"
    end
  end

  def update_popularity
    @popularity = Popularity.find(params[:id])
    if @popularity.update_attributes(params[:popularity])
      redirect_to :back, notice: "popularity success updated"
    else
      redirect_to :back, notice: "popularity fail updated"
    end
  end

  def delete_reward
    @reward = Reward.find(params[:id]).destroy
    redirect_to :back, notice: "reward deleted"
  end
  def delete_popularity
    @popularity = Popularity.find(params[:id]).destroy
    redirect_to :back, notice: "Popularity deleted"
  end
  def delete_loyalty
    @loyalty = Loyalty.find(params[:id]).destroy
    redirect_to :back, notice: "Loyalty deleted"
  end
end
