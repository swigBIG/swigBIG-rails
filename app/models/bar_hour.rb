class BarHour < ActiveRecord::Base
  attr_accessible :bar_id, :close, :open_hour, :day

  belongs_to :bar

  scope :monday, where(day: 'Monday')
  scope :tuesday, where(day: 'Tuesday')
  scope :wednesday, where(day: 'Wednesday')
  scope :thursday, where(day: 'Thursday')
  scope :friday, where(day: 'Friday')
  scope :saturday, where(day: 'Saturday')
  scope :sunday, where(day: 'Sunday')
end
