class Users::NotificationsController < ApplicationController
  layout "users"

  def index
    @bar_messages = BarMessage.where(user_id: current_user.id)
    @bar_messages = BarMessage.where(user_id: current_user.id)

    @bar_ids = current_user.swigers.pluck(:bar_id).uniq
#    @notifications = ActivityStream.where(["actor_id IN (?)", @bar_ids])
    @notifications = ActivityStream.all
  end
end
