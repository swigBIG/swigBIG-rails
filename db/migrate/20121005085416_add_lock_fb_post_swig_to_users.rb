class AddLockFbPostSwigToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_post_swig, :boolean
  end
end
