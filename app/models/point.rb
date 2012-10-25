class Point < ActiveRecord::Base
  attr_accessible :bar_id, :loyalty_points, :popularity_points, :reward_id, :type, :user_id,
    :complete_status, :redeem_status

  belongs_to :user
  belongs_to :bar
end
