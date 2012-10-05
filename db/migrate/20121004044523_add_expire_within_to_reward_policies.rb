class AddExpireWithinToRewardPolicies < ActiveRecord::Migration
  def change
    add_column :reward_policies, :expire_within, :integer
  end
end
