class Product < ActiveRecord::Base
  attr_accessible :bar_id, :name, :price

  belongs_to :bar
end
