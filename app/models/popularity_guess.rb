class PopularityGuess < ActiveRecord::Base
  belongs_to :popularity_inviter
  belongs_to :user
  belongs_to :swiger

  attr_accessible :fb_id, :popularity_inviter_id, :user_id, :enter_status, :bar_id, :email

  scope :today, where("created_at >= ? AND created_at  <= ?", Time.zone.now.beginning_of_day,  Time.zone.now.end_of_day)
  
end
