class AddRewardIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reward_id, :integer
  end
end
