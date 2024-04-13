require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john_doe)
  end

  test "user enters invalid information in edit form" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch(
      user_path(@user),
      params: {
        user: {
          name: '', email: 'user@meh', password: 'badpw',
          password_confirmation: 'ehmpw'
        }
      }
    )
    assert_template 'users/edit'
    assert_select "div[class='field_with_errors']"
  end

  test "user enters valid information in edit form" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "John Smith"
    email = "jsmith@spies.com"
    patch(
      user_path(@user),
      params: {
        user: {
          name: name, email: email, password: '', password_confirmation: ''
        }
      }
    )

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
