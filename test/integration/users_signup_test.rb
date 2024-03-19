require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post(
        users_path,
        params: {
          user: {
            name: "",
            email: "bad@email",
            password: 'foo',
            password_confirmation: 'bar'
        }}
      )
    end

    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div.field_with_errors'
  end

  test "successful signup" do
    get signup_path
    assert_difference 'User.count' do
      post(
        users_path,
        params: {
          user: {
            name: "Big Baller",
            email: "bigb@email.com",
            password: 'foobarbaz',
            password_confirmation: 'foobarbaz'
        }}
      )
    end

    assert_response :redirect
    assert_select 'div.field_with_errors', 0
  end
end
