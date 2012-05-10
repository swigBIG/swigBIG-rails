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
end
