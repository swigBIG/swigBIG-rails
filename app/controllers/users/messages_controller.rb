class Users::MessagesController < ApplicationController
layout "users"
  def index
    @messages = current_user.received_messages.page(params[:page]).per(10)
  end

  def sent
    @messages = current_user.sent_messages.page(params[:page]).per(10)
  end

  def new
    user_id = params[:user_id].split("--").first rescue nil
    user_type = params[:user_id].split("--").last rescue nil
    @recipient = user_type.constantize.find(user_id) rescue nil
    @message = ActsAsMessageable::Message.new
  end

  def create
    receiver = params[:acts_as_messageable_message][:received_messageable_id].split("--")
    received_messageable_id = receiver.first rescue nil
    received_messageable_type = receiver.last rescue nil
    @message = ActsAsMessageable::Message.new(
      params[:acts_as_messageable_message].merge({received_messageable_id: received_messageable_id, received_messageable_type: received_messageable_type })
    )
    if @message.save
      redirect_to(sent_students_messages_path, notice: "Your message has been successfully sent")
    else
      render action: :new
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

end
