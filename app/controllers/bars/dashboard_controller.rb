class Bars::DashboardController < ApplicationController
  layout "bars"
  
  
  before_filter :authenticate_bar!

  log_activity_streams :current_bar, :name, "Active Swigs",
    :@swig, :deal, :active_swig, :swig
  #
  #  log_activity_streams :current_bar, :name, "Message",
  #    :message, :deal, :create_bar_message, :swig

  def index
    @count = 0
    @big_swig_lists = current_bar.big_swig_lists
    #    render layout: "main_bars"
    @bar = current_bar
    @swigers = @bar.swigers
    @swigs_monday = @bar.swigs.monday.page(params[:page]).per(3)
    @swigs_tuesday = @bar.swigs.tuesday.page(params[:page]).per(3)
    @swigs_wednesday = @bar.swigs.wednesday.page(params[:page]).per(3)
    @swigs_thursday = @bar.swigs.thursday.page(params[:page]).per(3)
    @swigs_friday = @bar.swigs.friday.page(params[:page]).per(3)
    @swigs_saturday = @bar.swigs.saturday.page(params[:page]).per(3)
    @swigs_sunday = @bar.swigs.sunday.page(params[:page]).per(3)
    @gifts = @bar.gifts
    @swig = @bar.swigs.new
    @gift = @bar.gifts.new
    #    @reward = @bar.rewards.new
    @reward = []
    @loyal = Loyalty.new
    @popular = Popularity.new
    #    @popularity = @bar.rewards.where(reward_type: "Popularity")
    @popularity = current_bar.popularity
    #    @loyalty = @bar.rewards.where(reward_type: "Loyalty")
    #    @loyalty = Loyalty.where(bar_id: current_bar).first
    @loyalty = current_bar.loyalty
    @winner = @bar.winners.all
    @loyalty_reward = RewardMessage.new
    @bar_message = ActsAsMessageable::Message.new
    #    @bar_message = BarMessage.new
    unless params[:coupon].blank?
      @redeem = current_bar.messages.where(coupon: params[:coupon])
      unless @redeem.blank?
        @redeem_info = "Earned by #{User.find(@redeem.first.received_messageable_id).name} on #{@redeem.first.created_at.strftime('%v')}"
      else
        @redeem_info = "Unknow Code!"
      end
    else
      @redeem_info = ""
    end

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
    swig = current_bar.swigs.new(params[:swig])
    if swig.save
      redirect_to :back, notice: "Standard Swig created!"
    else
      redirect_to :back, notice: "Standard Swig Fail created!"
    end
  end

  def create_big_swig
    params[:deals].each_with_index do |deal, x|
      current_bar.swigs.create(:deal => deal, people: params[:peoples][params[:day]][x.to_s], :swig_day => params[:swig_day], :swig_type => params[:swig_type])
    end unless params[:deals].blank?
    redirect_to :back, notice: "Swig created"
  end

  def update_big_swig
    7.times do |day|
      params[:swig_ids].each_with_index do |id, x|
        Swig.find(id).update_attributes(deal: params[:deals][x],people: params[:people][x])
      end
    end
    redirect_to :back, notice: "Swig updated"
  end

  def delete_big_swig
    Swig.where(bar_id: params[:swig_ids]).destroy
    redirect_to bars_dashboard_url, notice: "BigSwig Deleted!"
  end

  def delete_swig
    Swig.find(params[:id]).destroy
    redirect_to bars_dashboard_url, notice: "Selected Swig Deleted!"
  end

  def update_swig
    @swig = current_bar.swigs.find(params[:id])
    if @swig.update_attributes(params[:swig])
      redirect_to :back, notice: "Swig update"
    else
      redirect_to :back, notice: "Swig fail update"
    end
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
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
      end
      redirect_to :back, notice: "Message success Send!"
    when "1"
      current_bar.swigers.where("created_at >= ?", params[:acts_as_messageable_message][:days].to_i.days.ago.beginning_of_day).pluck(:user_id).uniq.each do |user|
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
      end
      redirect_to :back, notice: "Message success Send to User last #{params[:number_days]}!"
    when "2"
      current_bar.points.where(loyalty_points: 1).group("user_id").count.each_pair do |key, val|
        swigs_required = current_bar.loyalty.swigs_number - val
        if swigs_required.eql?(params[:required_swigs])
          current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
        end
      end
      redirect_to :back, notice: "Message success Send!"
    when "3"
      user = User.find(params[:acts_as_messageable_message][:to])
      current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], reward_id: params[:acts_as_messageable_message][:reward_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
      redirect_to :back, notice: "Reward Message success Send!"
    when "4"
      current_bar.winners.pluck(:user_id).each do |u_id|
        user = User.find(u_id)
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], reward_id: params[:acts_as_messageable_message][:reward_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
      end
      redirect_to :back, notice: "Reward Message success Send!"
    when "5"
      user = User.find(params[:acts_as_messageable_message][:to])
      current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
      redirect_to :back, notice: "Message success Send!"

    when "6" #buat pie chart 25%
      current_bar.points.group(:user_id).count.each_pair do |key, val|
        #      current_bar.swigers.group(:user_id).count.each_pair do |key, val|
        if (val.to_f / current_bar.loyalty.swigs_number.to_f * 100) <= 25 && (val.to_f / current_bar.loyalty.swigs_number.to_f * 100) >= 2
          user = User.find(key)
          current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
        end
      end
      redirect_to :back, notice: "Message success Send! to 25%"

    when "7" #buat pie chart
      current_bar.points.group(:user_id).count.each_pair do |key, val|
        #      current_bar.swigers.group(:user_id).count.each_pair do |key, val|
        if (val.to_f / current_bar.loyalty.swigs_number.to_f * 100) <= 50 && (val.to_f / current_bar.loyalty.swigs_number.to_f * 100) >= 26
          user = User.find(key)
          current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
        end
      end
      redirect_to :back, notice: "Message success Send! to 50%"
    when "8" #buat pie chart
      current_bar.points.group(:user_id).count.each_pair do |key, val|
        #      current_bar.swigers.group(:user_id).count.each_pair do |key, val|
        if (val.to_f / current_bar.loyalty.swigs_number.to_f * 100) <= 75 && (val.to_f / current_bar.loyalty.swigs_number.to_f * 100) >= 51
          user = User.find(key)
          current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category], gift_id: params[:acts_as_messageable_message][:gift_id], expirate_reward: params[:acts_as_messageable_message][:expirate_reward]})
        end
      end
      redirect_to :back, notice: "Message success Send! to 75%"

    when "17"
      current_bar.messages.where(coupon_status: true).pluck(:received_messageable_id).each do |u|
        user = User.find(u)
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category]})
      end
      redirect_to :back, notice: "Message succes send to all users that have not used their rewards!"
    when "30"
      user = params[:acts_as_messageable_message][:to].split(",").each do |u|
        user = User.find(u)
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category]})
      end
      redirect_to :back, notice: "Message success Send!"
    when "31"
      user = params[:acts_as_messageable_message][:to].split(",").each do |u|
        user = User.find(u)
        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category]})
      end
      redirect_to :back, notice: "Message success Send!"
    else
      #      user = params[:acts_as_messageable_message][:to].split(",").each do |u|
      #        user = User.find(u)
      #        current_bar.send_message(user, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: params[:acts_as_messageable_message][:category]})
      #      end
      redirect_to :back, notice: "Failed sent message!"
    end
  end

  def update_completion
    @bar = current_bar
    current_bar.swigs.create(deal: params[:swig], swig_type: "Standard", swig_day: Time.zone.now.to_time.in_time_zone.strftime("%A"))
    current_bar.messages.first.update_attributes(opened: true)
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    (params[:total].to_i + 1).times do |t|
      unless params["first_day_#{t}"].blank?
        if params["close_day#{t}"].eql?("1")
          days[params["first_day_#{t}"].to_i..params["last_day#{t}"].to_i].each do |day|
            current_bar.bar_hours.create(day: day, open_time: "close")
          end
        else
          days[params["first_day_#{t}"].to_i..params["last_day#{t}"].to_i].each do |day|
            current_bar.bar_hours.create(day: day, open_time: "#{params["open_hour#{t}"].to_i}#{params["open_word#{t}"]}", close_time: "#{params["close_hour#{t}"].to_i}#{params["close_word#{t}"]}", open_hour: params["open_hour#{t}"].to_i, close: params["close_hour#{t}"].to_i,open_word: params["open_word#{t}"],close_word: params["close_word#{t}"], close_day: params["close_day#{t}"])
          end
        end
      end
    end

    if @bar.update_attributes(params[:bar])
      sign_in @bar, :bypass => true
      redirect_to bars_dashboard_path, notice: "Profile Completion Success!"
      #      redirect_to bars_second_completion_path, notice: "Profile Completion Success!"
    else
      redirect_to :back, notice: "Profile Completion Failed!"
    end
  end

  def completion
    @bar = current_bar
    @count = 0
    render layout: "main_bars"
  end

  def second_completion
    @bar = current_bar
    @popularity = Popularity.new
    @loyalty = Loyalty.new
    @bar_loyalty = current_bar.loyalty
    @bar_popularity = current_bar.popularity
  end

  def update_second_completion
    @bar = current_bar
    current_bar.swigs.create(deal: params[:swig], swig_type: "Standard", swig_day: Time.zone.now.to_time.in_time_zone.strftime("%A"))
    if @bar.update_attributes(params[:bar])
      sign_in @bar, :bypass => true
      redirect_to bars_dashboard_path, notice: "Profile Completion Success!"
    else
      redirect_to :back, notice: "Profile Completion Failed!"
    end
  end

  def create_gift
    @gift = current_bar.gifts.new(params[:gift])
    if @gift.save
      redirect_to :back, notice: "Gift success create!"
    else
      redirect_to :back, notice: "Gift failed create!"
    end
  end

  def activate_loyalty
    @loyalty = Loyalty.find(params[:loyalty_id])
    if @loyalty.update_attributes(status: "active")
      redirect_to :back, notice: "#{@loyalty.reward_detail} status Active!"
    else
      redirect_to :back, notice: "#{@loyalty.reward_detail} failed Active!"
    end
  end

  def deactivate_loyalty
    @loyalty = Loyalty.find(params[:loyalty_id])
    if @loyalty.update_attributes(status: nil)
      redirect_to :back, notice: "#{@loyalty.reward_detail} status Deactive!"
    else
      redirect_to :back, notice: "#{@loyalty.reward_detail} failed Deactive!"
    end
  end
  
  def activate_popularity
    @popularity = Popularity.find(params[:popularity_id])
    if @popularity.update_attributes(status: "active")
      redirect_to :back, notice: "#{@popularity.reward_detail} status Active!"
    else
      redirect_to :back, notice: "#{@popularity.reward_detail} failed Active!"
    end
  end

  def deactivate_popularity
    @popularity = Loyalty.find(params[:popularity_id])
    if @popularity.update_attributes(status: nil)
      redirect_to :back, notice: "#{@popularity.reward_detail} status Deactive!"
    else
      redirect_to :back, notice: "#{@popularity.reward_detail} failed Deactive!"
    end
  end

  def update_gift
    @gift = Gift.find(params[:id])
    if @gift.update_attributes(params[:gift])
      redirect_to :back, notice: "gift success change!"
    else
      redirect_to :back, notice: "gift not change!"
    end
  end

  def destroy_gift_in_list
    @gift = Gift.find(params[:id])
    @gift.destroy
    redirect_to :back, notice: "Gift Success delete"
  end

  def sport_lists
    sport_groups = SportTeam.select('id, team_name').where(["team_name LIKE ?", "%#{params[:q]}%"])
    @sport_lists = []
    sport_groups.each do |sport_group|
      @sport_lists << {id: sport_group.team_name, name: sport_group.team_name}
    end
    respond_to do |format|
      format.json  { render :json => @sport_lists }
    end
  end

  def users_lists
    #    users_groups = User.where(["name IS NOT NULL"]).where([" name LIKE ?", "%#{params[:q]}%"])
    users_groups = User.select("id, name").where(["name IS NOT NULL AND name LIKE ?", "%#{params[:q]}%"])
    @users_lists = []
    users_groups.each do |user|
      @users_lists << {id: user.id, name: user.name}
    end
    respond_to do |format|
      format.json  { render :json => @users_lists }
    end
  end

  def after_join_invite_friends

  end

  def invite_friend_by_email
    unless params[:mytags].blank?
      params[:mytags].split(",").each do |email|
        Invite.invite_to_swigbig(email, current_bar).deliver
      end
      redirect_to bars_completion_url, notice: "invite success!"
    else
      redirect_to :back, notice: "undefine email address!"
    end

  end

  def add_bigswig_list
    @bigswig_list = current_bar.big_swig_lists.new(params[:big_swig_list])
    if @bigswig_list.save
      @big_swig_lists = current_bar.big_swig_lists.order("created_at DESC")
      respond_to { |format| format.js }
    end
  end

  def add_bigswig_list_on_update
    @bigswig_list = current_bar.big_swig_lists.new(params[:big_swig_list])
    @big_swig_list = params[:deal_ids]
    
    if @bigswig_list.save
      respond_to { |format| format.js }
    end
  end

  def add_bar_hours
    @count = params[:id]
    @counter = params[:count]
    respond_to { |format| format.js }
  end
  #  def sport_lists
  #    @sport_teams = SportTeam.where("name like ?", "%#{params[:q]}%")
  #    respond_to do |format|
  #      format.html
  #      format.json { render :json => @sport_teams.map(&:attributes) }
  #    end
  #  end

  def destroy_bar_big_swig_list
    bigswig_list = BigSwigList.find(params[:bigswiglist_id].to_i)
    bigswig_list.destroy
    session[:show_big_list] = true
    redirect_to bars_dashboard_url
  end

  #  def destroy_bar_big_swig_list
  #    bigswig_list = BigSwigList.find(params[:bigswiglist_id].to_i)
  #    if @bigswig_list.save
  #      @big_swig_lists = current_bar.big_swig_lists.order("created_at DESC")
  #      respond_to { |format| format.js }
  #    end
  #  end
  
  def update_bar_big_swig_list
    bigswig = BigSwigList.find(params[:bigswiglist_id])
    if bigswig.update_attributes(params[:big_swig_list])
      redirect_to bars_dashboard_url, notice: "Update success!"
    else
      redirect_to bars_dashboard_url, notice: "Update failed!"
    end
  end

end













#def invite_by_email
#    @bar = Bar.find(params[:bar_ids][:bar_id])
#    @popularity_inviter = @bar.popularity_inviters.new(user_id: current_user.id )
#    if @popularity_inviter.save
#      if  !params[:mytags].blank?
#        @popularity_inviter.popularity_guesses.create(user_id: current_user.id, bar_id: @popularity_inviter.bar_id, fb_id: current_user.fb_id)
#        params[:mytags].split(",").each do |email|
#          Invite.send_invite_email(email, current_user, @bar).deliver
#          user = User.where(email: email).first
#          if user
#            @popularity_inviter.popularity_guesses.create(user_id: user.id, email: email, bar_id: @popularity_inviter.bar_id)
#          else
#            @popularity_inviter.popularity_guesses.create(user_id: nil, email: email, bar_id: @popularity_inviter.bar_id)
#          end
#        end
#        redirect_to :back, notice: "Success Create Popularity!"
#      else
#        @popularity_inviter.destroy
#        redirect_to :back, notice: "Empty Guess!"
#      end
#    else
#      redirect_to :back, notice: "Fail Create Popularity!"
#    end
#  end

