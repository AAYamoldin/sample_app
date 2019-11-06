require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
    test "should be valid" do
    assert @user.valid?
  end
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end
  test "email should be valid" do
    @user.email = "   "
    assert_not @user.valid?
  end
  test "name should not to be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  test "email validation should assept valid addr" do
    valid_addr = %w[user@example.com
user@foo.COM A_US-ER@foo.bar.org
first.last@foo.jp lll@kuk.com]
    valid_addr.each do |valid_addres|
      @user.email = valid_addres
      assert @user.valid?, "#{valid_addres.inspect} should be valid"
    end
  end
  test "email addresses should be unique" do
  duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  test "email addresses should be save as lower-case" do
    mixed_case_email = "FOO@ExAmPlE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  test "authenticated? should return false for a user with nill digest" do
    assert_not @user.authenticated?(:remember , '')
  end
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end

