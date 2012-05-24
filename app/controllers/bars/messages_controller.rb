class Bars::MessagesController < ApplicationController

   def index
    @messages = current_bar.received_messages.page(params[:page]).per(10)
  end

  def sent
    @messages = current_bar.sent_messages.page(params[:page]).per(10)
  end

  def new
    bar_id= params[:bar_id].split("--").first rescue nil
    bar_type = params[:bar_id].split("--").last rescue nil
    @recipient = user_type.constantize.find(bar_id) rescue nil
    @message = ActsAsMessageable::Message.new
  end

  def create
    @message = ActsAsMessageable::Message.new(params[:acts_as_messageable_message])
    if @message.save
      redirect_to :back, notice: "Your message has been successfully sent"
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
          current_bar.delete_message(message)
        end
      when "4"
        messages.each do |message|
          current_bar.delete_message(message)
        end
      end
    end
    redirect_to params[:form_type].blank? ? students_messages_path : trash_students_messages_path
  end

  def trash
    @messages = current_bar.deleted_messages.page(params[:page]).per(10)
  end

end
