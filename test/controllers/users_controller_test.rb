require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
def setup
  @user = users(:michael)
end
  test "should get new" do
    get signup_path
    assert_response :success
  end
test "should redirect edit when not logged in" do
  get edit_user_path(@user) #runing action "create " in usr controller
  assert_not flash.empty? #not empty flash message
  assert_redirected_to login_path
end
  test "should redirect update when not logged in" do
    patch user_path(@user), #running action "update" in user controller
          params: { user: {name: @user.name,
          email: @user.email}}
  assert_not flash.empty?
    assert_redirected_to login_path
  end
end
