class AddLockStatusToBars < ActiveRecord::Migration
  def change
    add_column :bars, :lock_status, :boolean, default: 0
  end
end
