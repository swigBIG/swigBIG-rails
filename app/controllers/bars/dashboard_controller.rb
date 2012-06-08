class Bars::DashboardController < ApplicationController
  layout "bars"
  before_filter :authenticate_bar!

  log_activity_streams :current_bar, :name, "Active Swigs",
    :@swig, :deal, :active_swig, :swig
#
#  log_activity_streams :current_bar, :name, "Message",
#    :message, :deal, :create_bar_message, :swig

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
    #    @loyalty = Loyalty.where(bar_id: current_bar).first
    @loyalty = current_bar.loyalty
    @winner = @bar.winners.all
    @loyalty_reward = RewardMessage.new
    @bar_message = ActsAsMessageable::Message.new
    #    @bar_message = BarMessage.new
  end

  def show
  end

  def create_reward_message
    @winner = Winner.find(params[:user_id])
    @reward_message = RewardMessage.new(bar_id: current_bar.id, user_id: params[:user_id], content: params[:reward_message][:content], subject: params[:reward_message][:subject])
    if @reward_message.save
      redirect_to :back, notice: "Success Send"
    else
      redirect_to :back, notice: "Failed Send"
    end
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

  def create_bar_message
    case params[:acts_as_messageable_message][:category]
    when "0"
      User.all.each do |user|
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id]})
      end
      redirect_to :back, notice: "Message success Send!"
    when "1"
      current_bar.swigers.where("created_at >= ?", params[:acts_as_messageable_message][:days].to_i.days.ago.beginning_of_day).pluck(:user_id).uniq.each do |user|
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category]})
      end
      redirect_to :back, notice: "Message success Send to User last #{params[:number_days]}!"
    when "2"
      current_bar.points.where(loyalty_points: 1).group("user_id").count.each_pair do |key, val|
        swigs_required = current_bar.loyalty.swigs_number - val
        if swigs_required.eql?(params[:required_swigs])
          current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category]})
        end
      end
      redirect_to :back, notice: "Message success Send!"
    else
      redirect_to :back, notice: "Failed sent message!"
    end
    #    redirect_to :back, notice: "Message success Send!"
  end

  def update_completion
    @bar = current_bar
    if @bar.update_attributes(params[:bar])
      sign_in @bar, :bypass => true
      redirect_to bars_dashboard_path, notice: "Profile Completion Success!"
    else
      redirect_to :back, notice: "Profile Completion Failed!"
    end
  end

  def completion
    @bar = current_bar
  end

end
