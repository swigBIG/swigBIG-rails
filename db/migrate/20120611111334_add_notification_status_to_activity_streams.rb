class AddNotificationStatusToActivityStreams < ActiveRecord::Migration
  def change
    add_column :activity_streams, :notification_status, :string
  end
end
