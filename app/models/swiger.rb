class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id

  belongs_to :swig
end
