require 'test_helper'

class Users::SwigFriendsListControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
