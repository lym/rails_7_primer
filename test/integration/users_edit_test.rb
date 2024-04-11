require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john_doe)
  end

  test "user enters invalid information in edit form" do
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
end
