require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john_doe)
    @jane = users(:jane_doe)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect from index view when a user is not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "redirect edit page requests when user is not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "redirect patch requests when a user is not logged in" do
    patch(
      user_path(@user), params: {user: {name: @user.name, email: @user.email}}
    )
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "wrong user attempts to access edit form" do
    log_in_as @jane
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "wrong user attempts to submit edit form" do
    log_in_as @jane
    patch(
      user_path(@user), params: {user: {name: @user.name, email: @user.email}}
    )

    assert flash.empty?
    assert_redirected_to root_url
  end

  test "Guest users who attempt delete should be redirected to login page" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "Non-admins who attempt delete should be redirected to root URL" do
    log_in_as @jane
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "accessing followed users while logged out" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "accessing followers while logged out" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
