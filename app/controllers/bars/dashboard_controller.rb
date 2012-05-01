class Bars::DashboardController < ApplicationController
  layout "bars"

  def index
    @bar = current_bar
    @swig = @bar.swigs.new
    @swigs = @bar.swigs
    @reward = @bar.rewards.new
    @popularity = @bar.rewards.where(reward_type: "Popularity")
    @loyalty = @bar.rewards.where(reward_type: "Loyalty")

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

  def create_reward
    @reward = current_bar.rewards.new(params[:reward])
    if @reward.save
      redirect_to :back, notice: "reward success added"
    else
      redirect_to :back, notice: "reward fail added"
    end
  end

  def update_reward
    @reward = Reward.find(params[:id])
    if @reward.update_attributes(params[:reward])
      redirect_to :back, notice: "reward success updated"
    else
      redirect_to :back, notice: "reward fail updated"
    end
  end

  def delete_reward
    @reward = Reward.find(params[:id]).destroy
    redirect_to :back, notice: "reward deleted"
  end
end
