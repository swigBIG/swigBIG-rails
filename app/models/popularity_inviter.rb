class PopularityInviter < ActiveRecord::Base
  belongs_to :bar
  belongs_to :user
  belongs_to :popularity
  has_many :popularity_guesses

  attr_accessible :bar_id, :fb_id, :user_id

end
