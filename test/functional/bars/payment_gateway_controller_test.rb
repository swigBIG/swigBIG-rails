require 'test_helper'

class Bars::PaymentGatewayControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
