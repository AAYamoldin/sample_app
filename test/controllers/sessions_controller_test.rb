require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do

    #get sessions_new_url
    #лучше
    get login_path
    assert_response :success
  end

end
