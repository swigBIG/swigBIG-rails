class PopularityInviter < ActiveRecord::Base
  belongs_to :bar
  belongs_to :user
  belongs_to :popularity
  has_many :popularity_guesses, dependent: :destroy

  validate :popularity_valid?

  attr_accessible :bar_id, :fb_id, :user_id, :users_inviters_id, :email

  scope :today, where("created_at >= ? AND created_at  <= ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day)
  scope :valid_time, where("created_at <= ? AND created_at  >= ?", Time.zone.now,  (Time.zone.now + (TimeSwigging.first.time_between_swig rescue 3).hours ).to_date )

  def popularity_invitations
    self.users_inviters_id.split(",").each do |id|
      self.bar.send_message(guess.user, {topic: "#{self.user.name} invite to #{self.bar.name}", body: "Come to #{self.bar.name} and unlock #{self.bar.popularity.reward_detail}!!", category: 11})
    end
  end

  def popularity_valid?
    unless self.user.popularity_inviters.today.blank?
      return true
    else
      return false
    end
  end
  
end
