module ApplicationHelper

  def bar_products
    current_bar.products.map {|p| [p.name, p.id]}
  end
end
