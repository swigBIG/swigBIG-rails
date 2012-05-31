class BarHour < ActiveRecord::Base
  attr_accessible :bar_id, :close, :open, :day

  belongs_to :bar
end
