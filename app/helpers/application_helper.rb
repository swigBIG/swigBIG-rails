module ApplicationHelper

  def bar_products
    current_bar.products.map {|p| [p.name, p.id]}
  end

  def states_collection
    States.pluck(:name)
  end
end
