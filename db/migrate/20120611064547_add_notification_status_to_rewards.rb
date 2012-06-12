class AddNotificationStatusToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :notification_status, :string
  end
end
