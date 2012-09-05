class BarHour < ActiveRecord::Base
  attr_accessible :bar_id, :close, :open_hour, :day, :open_time, :close_time, :open_word, :close_word,
    :close_day

  belongs_to :bar

  scope :monday, where(day: 'Monday')
  scope :tuesday, where(day: 'Tuesday')
  scope :wednesday, where(day: 'Wednesday')
  scope :thursday, where(day: 'Thursday')
  scope :friday, where(day: 'Friday')
  scope :saturday, where(day: 'Saturday')
  scope :sunday, where(day: 'Sunday')

  #  before_update :bar_time_hour
  #
  #  def bar_time_hour
  #    self.open_time = "#{self.open_hour.to_i}.#{self.open_word}"
  #    self.close_time = "#{self.close.to_i}.#{self.close_word}"
  #  end

  before_save :close_day_checker

  def close_day_checker
    if self.close_day
      self.open_time = "Close"
      self.close_time = "Close"
#    else
#      self.open_time = "#{self.open_hour.to_i}.#{self.open_word}"
#      self.close_time = "#{self.close.to_i}.#{self.close_word}"
    end
  end
  
end
