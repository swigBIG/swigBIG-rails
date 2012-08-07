class BigSwigList < ActiveRecord::Base
  attr_accessible :bar_id, :big_swig, :category

  belongs_to :bar
end
