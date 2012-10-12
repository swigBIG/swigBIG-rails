class RequestUser < ActiveRecord::Base
  attr_accessible :email, :enter_key, :full_name

  validates :email, :uniqueness => true, :presence => true
end
