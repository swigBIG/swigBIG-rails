class BarRadius < ActiveRecord::Base
  attr_accessible :distance, :status

  validates :distance, :uniqueness => true, :numericality => true, :presence => true
end
