class Reward < ActiveRecord::Base
  attr_accessible :bar_id, :lock_status, :reward_detail, :reward_type, :swigs_number

  belongs_to :bar
end
