class ChangeDefaultToFbLockPostingToUsers < ActiveRecord::Migration
  def up
    change_column :users, :lock_fb_post, :boolean, default: false
    change_column :users, :fb_post_swig, :boolean, default: false
  end

  def down
    change_column :users, :lock_fb_post, :boolean
    change_column :users, :fb_post_swig, :boolean
  end
end
