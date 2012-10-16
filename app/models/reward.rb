class Reward < ActiveRecord::Base
  attr_accessible :bar_id, :lock_status, :reward_detail, :reward_type, 
    :swigs_number, :type, :status, :notification_status

  scope :active, where(status: "active")
end
