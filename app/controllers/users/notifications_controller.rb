class Users::NotificationsController < ApplicationController
  layout "users"

  def index
    @bar_messages = BarMessage.where(user_id: current_user.id)
  end
end
