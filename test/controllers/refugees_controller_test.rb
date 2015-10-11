require 'test_helper'

class RefugeesControllerTest < ActionController::TestCase
  test "should get count" do
    get :count
    assert_response :success
  end

end
