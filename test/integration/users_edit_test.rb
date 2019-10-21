require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
def setup
  @user = users(:michael)
end
  test "unsuccessful edit" do
    log_in_as(@user) #this was download from test-helper
    get edit_user_path(@user)#running in controler method "edit"
    assert_template 'users/edit'
    patch user_path(@user), #patch running in usr controllet method "update"
          params: {user: {name: "",
          email: "foo@invalid",
          passsword: "lol",
          password_confirmation: "kek"}}
assert_template "users/edit"
  end


  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)#running in controllet "edit" method
    assert_template "users/edit"
    name = "foo bar"
    email = "foo@bar.com"
    patch user_path(@user), #running "update method"
          params: {user:{ name: name,
          email: email,
          password: "",
          password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload #отмена изменений, из бд вспоминаем имя-емейл
    assert_equal name, @user.name #control matching with db
    assert_equal email, @user.email

  end
end
