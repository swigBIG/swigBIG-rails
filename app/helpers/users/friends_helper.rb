module Users::FriendsHelper

  def check_friend(user1,user2)
    return if user1.eql?(user2)
    if user1.friend_with?(user2)
      "<div class=\"\">  Already friend</div>".html_safe
    elsif user1.connected_with?(user2)
      " <div class=\"\"> Request Pending </div>".html_safe
    else
      " <div class=\"\">  #{button_to "Add as Friend", users_friend_request_path(user2.id.to_i), class: 'btn-success btn-mini'} </div>".html_safe
    end
  end

  #<%= check_friend(current_user, user) %>

end
