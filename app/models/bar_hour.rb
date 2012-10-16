class BarHour < ActiveRecord::Base
  attr_accessible :bar_id, :close, :open_hour, :day, :open_time, :close_time,
    :open_word, :close_word, :close_day

  belongs_to :bar

  scope :monday, where(day: 'Monday')
  scope :tuesday, where(day: 'Tuesday')
  scope :wednesday, where(day: 'Wednesday')
  scope :thursday, where(day: 'Thursday')
  scope :friday, where(day: 'Friday')
  scope :saturday, where(day: 'Saturday')
  scope :sunday, where(day: 'Sunday')

  before_save :close_day_checker

  DAY_LIST = {
    "Monday" => 0,
    "Tuesday"=> 1,
    "Wednesday" => 2,
    "Thursday" => 3,
    "Friday" => 4,
    "Saturday" => 5,
    "Sunday"=> 6
  }

  def close_day_checker

    if self.close_day
      self.open_time = "Close"
      self.close_time = "Close"
    end
    
  end
  
end
