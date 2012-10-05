class RewardPolicy < ActiveRecord::Base
  attr_accessible :loyalty_expirate_date, :popularity_expirate_hours

  validates :loyalty_expirate_date, :popularity_expirate_hours, :expire_within, :numericality => true
end
