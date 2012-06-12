module ApplicationHelper

  def bar_products
    current_bar.products.map {|p| [p.name, p.id]}
  end

  def states_collection
    States.pluck(:name)
  end

  def user_collection
    #  User.all.map{|u| [u.name, u.id]}
    User.all
  end

  def days
    [["Monday","Monday"],["Tuesday","Tuesday"],["Wednesday","Wednesday"],["Thursday","Thursday"],["Friday","Friday"],["Saturday","Saturday"],["Sunday","Sunday"]]
  end

  def avaliable_cities
    City.all.map{|c| [c.name, c.name]}
  end

  def sport_teams_collection
    SportTeam.all.map{ |s| [s.team_name, s.team_name] }
  end

  def radius_collection
    GeoRadius.order("radius").all.map{ |g| [g.radius, g.radius] }
  end

  def gift_collections
    Gift.where(["bar_id is NULL OR bar_id = (?)", current_bar.id ]).map{ |g| [g.name, g.id] }
  end

  def reward_collections
    Reward.where(["bar_id = (?) OR bar_id = (?)", nil, current_bar.id ]).all.map{ |g| [g.name, g.id] }
  end

end
