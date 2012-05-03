class AddRewardToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :type, :string
  end
end
