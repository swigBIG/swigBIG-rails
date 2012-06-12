class WinnerReward < ActiveRecord::Base
  attr_accessible :bar_id, :content, :name, :winner_id

  belongs_to :bar
  belongs_to :winner
end
