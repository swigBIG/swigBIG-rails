class PopularityGuess < ActiveRecord::Base
  belongs_to :popularity_inviter
  belongs_to :user

  attr_accessible :fb_id, :popularity_inviter_id, :user_id, :enter_status
end
