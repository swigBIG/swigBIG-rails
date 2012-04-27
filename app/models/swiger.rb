class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
end
