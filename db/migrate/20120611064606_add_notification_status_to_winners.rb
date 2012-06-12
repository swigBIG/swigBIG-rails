class AddNotificationStatusToWinners < ActiveRecord::Migration
  def change
    add_column :winners, :notification_status, :string
  end
end
