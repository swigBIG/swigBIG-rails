class AddLockFbPostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lock_fb_post, :boolean
  end
end
