class Point < ActiveRecord::Base
  attr_accessible :bar_id, :loyalty_points, :popularity_points, :reward_id, :type, :user_id

  belongs_to :user
end
