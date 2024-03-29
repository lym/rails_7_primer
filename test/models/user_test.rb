require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Test User', email: 'test.user@example.com',
      password: "passweeds", password_confirmation: "passweeds"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "foo" * 50
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "#{'bar' * 250}@example.com"
    assert_not @user.valid?
  end

  test "valid email addresses should be accepted" do
    valid_addresses =  %w[
      USER@foo.COM THE_US-ER@foo.bar.org first.last@foo.jp jamie+smith@gov.cn
    ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "invalid email addresses should be rejected" do
    invalid_addresses = %w[
      user@example,com user_at_foo.org user.name@example. foo@bar_baz.com
      foo@foo+bar.com
    ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "weeds"
    assert_not @user.valid?
  end
end
