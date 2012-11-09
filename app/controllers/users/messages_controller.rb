class Users::MessagesController < ApplicationController
  layout "users"
  def index
    @messages = current_user.received_messages.order("created_at DESC").page(params[:page]).per(10)
  end

  def sent
    @messages = current_user.sent_messages.page(params[:page]).per(10)
    #    @messages = User.find(14).sent_messages
  end

  def new
    user_id = params[:user_id].split("--").first rescue nil
    user_type = params[:user_id].split("--").last rescue nil
    @recipient = user_type.constantize.find(user_id) rescue nil
    @message = ActsAsMessageable::Message.new
  end

  def create
    unless params[:acts_as_messageable_message][:reward].to_i.eql?(22)
      send_to = Bar.find(params[:acts_as_messageable_message][:to])
    else
      send_to = AdminUser.first
    end


    if send_to
      current_user.send_message(send_to, {
          topic: params[:acts_as_messageable_message][:topic],
          body: params[:acts_as_messageable_message][:body],
          category: params[:acts_as_messageable_message][:category]
        })
      redirect_to users_messages_path, notice: 'succses'
    else
      redirect_to :back, notice: 'succses'
    end
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
          current_user.delete_message(message)
        end
      when "4"
        messages.each do |message|
          current_user.delete_message(message)
        end
      end
    end
    redirect_to params[:form_type].blank? ? users_messages_path : trash_users_messages_path
  end

  def trash
    @messages = current_user.deleted_messages.page(params[:page]).per(10)
  end

  def notifications
    @notifications = current_user.messages.where(category: [22, 1, 9, 10, 15, 16, 17, 18]).page(params[:page]).per(5)
    end

  def notify_mark_all_read
    current_user.messages.update_all('notify_opended = true')
    #    current_user.messages.each do |message|
    #      message.notify_mark_as_read
    #    end

    @total_notification = current_user.received_messages.where(notify_opended: false).count.to_s
    respond_to :js
  end

  def messages_mark_all_read
    current_user.messages.update_all('opened = true')
    #    current_user.messages.each do |message|
    #      message.notify_mark_as_read
    #    end

    @total_notification = current_user.received_messages.where(opened: false).count.to_s
    respond_to :js
  end

end
