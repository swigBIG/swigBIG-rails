class AddLockStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lock_status, :boolean, default: 0
  end
end
