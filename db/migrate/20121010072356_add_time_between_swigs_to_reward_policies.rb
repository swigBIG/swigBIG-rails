class AddTimeBetweenSwigsToRewardPolicies < ActiveRecord::Migration
  def change
    add_column :reward_policies, :time_between_swig, :integer
  end
end
