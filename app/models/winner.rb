class Winner < ActiveRecord::Base
  attr_accessible :bar_id, :loyalty_id, :reward_id, :user_id, :notification_status,
    :coupon, :coupon_status

  belongs_to :bar
  belongs_to :user

  has_many :reward_messages
  has_many :winner_rewards

end
