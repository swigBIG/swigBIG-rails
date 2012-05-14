class Winner < ActiveRecord::Base
  attr_accessible :bar_id, :loyalty_id, :reward_id, :user_id

  belongs_to :bar
  belongs_to :user

  has_many :reward_message

end
