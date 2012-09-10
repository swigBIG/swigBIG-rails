class CreateRewardPolicies < ActiveRecord::Migration
  def change
    create_table :reward_policies do |t|
      t.integer :loyalty_expirate_date
      t.integer :popularity_expirate_hours

      t.timestamps
    end
  end
end
