class SportTeam < ActiveRecord::Base
  attr_accessible :category, :team_name

  validates :category, :team_name, :presence => true
  validates :team_name, :uniqueness => true

end
