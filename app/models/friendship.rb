class Friendship < ActiveRecord::Base
  include Amistad::FriendshipModel
  attr_accessible :user_id, :friend_id
end
