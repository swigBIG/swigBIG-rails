class AddLockStatusToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :lock_status, :string
  end
end
