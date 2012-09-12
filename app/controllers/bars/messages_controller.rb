class Bars::MessagesController < ApplicationController
  layout "bars"

  log_activity_streams :current_bar, :name, "Active Swigs",
    :@swig, :deal, :active_swig, :swig

  def index
    @messages = current_bar.received_messages.page(params[:page]).per(10)
  end

  def sent
    @messages_all_user = current_bar.sent_messages.where(category: 5).group(:created_at).page(params[:page]).per(10)
    @messages_last_visit = current_bar.sent_messages.where(category: 1).group(:created_at).page(params[:page]).per(10)
    @messages_almost_rewarded = current_bar.sent_messages.where(category: 2).group(:created_at).page(params[:page]).per(10)
  end

  def new
    @message = ActsAsMessageable::Message.new
  end

  def create
    case params[:category]
    when "0"
      User.all.each do |user|
        BarMessage.create(params[:bar_message].merge(user_id: user.id))
        @message = ActsAsMessageable::Message.new(params[:acts_as_messageable_message])
      end
    when "1"
      User.all.each do |user|
        BarMessage.create(params[:bar_message].merge(user_id: user.id))
      end
    when "2"
      User.all.each do |user|
        BarMessage.create(params[:bar_message].merge(user_id: user.id))
      end
    end
    redirect_to :back, notice: "Message success Send!"
    if @message.save
      redirect_to :back, notice: "Your message has been successfully sent"
    else
      render action: :new
    end
  end

  def create_bar_message
  end

  def show
    @message_show = ActsAsMessageable::Message.find(params[:id])
    @message_show.mark_as_read
    @message = ActsAsMessageable::Message.new
  end

  def custom_action
    unless params[:message_ids].blank?
      messages = ActsAsMessageable::Message.where("id IN (?)",params[:message_ids])
      case params[:custom_action]
      when "1"
        messages.each do |message|
          message.mark_as_read
        end
      when "2"
        messages.each do |message|
          message.mark_as_unread
        end
      when "3"
        messages.each do |message|
          current_bar.delete_message(message)
        end
      when "4"
        messages.each do |message|
          current_bar.delete_message(message)
        end
      end
    end
    redirect_to params[:form_type].blank? ? bars_messages_path : trash_bars_messages_path
  end

  def trash
    @messages = current_bar.deleted_messages.page(params[:page]).per(10)
  end

  def notification
    @notification_unlock_swig = current_bar.sent_messages.where(["category = (?)", 15]).order("created_at DESC").page(params[:page]).per(10)
    @notification_unlock_popularity = current_bar.sent_messages.where(["category = (?)", 9]).order("created_at DESC").page(params[:page]).per(10)
    @notification_unlock_loyalty = current_bar.sent_messages.where(["category = (?)", 16]).order("created_at DESC").page(params[:page]).per(10)
#    @messages_all_user = current_bar.sent_messages.where(category: 0).group(:created_at).page(params[:page]).per(10)
#    @messages_last_visit = current_bar.sent_messages.where(category: 1).group(:created_at).page(params[:page]).per(10)
#    @messages_almost_rewarded = current_bar.sent_messages.where(category: 2).group(:created_at).page(params[:page]).per(10)
  end

  def message_popup
    @bar_message = ActsAsMessageable::Message.new
  end

end
