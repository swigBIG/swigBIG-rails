class Guess < ActiveRecord::Base
  attr_accessible :popularity_id, :user_id

  belongs_to :popularity , dependent: :destroy
end
