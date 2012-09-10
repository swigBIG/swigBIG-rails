class RewardPolicy < ActiveRecord::Base
  attr_accessible :loyalty_expirate_date, :popularity_expirate_hours
end
