class GeoRadius < ActiveRecord::Base
  attr_accessible :radius

   validates :radius, :uniqueness => true, :numericality => true, :presence => true
end
