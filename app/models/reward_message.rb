class RewardMessage < ActiveRecord::Base
  attr_accessible :bar_id, :content, :subject, :user_id, :winner_id
end
