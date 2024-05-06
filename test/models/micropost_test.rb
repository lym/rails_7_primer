require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:john_doe)
    @micropost = @user.microposts.build(
      content: 'A test micropost', user: @user
    )
  end

  test "A post with all required attributes should be valid" do
    assert @micropost.valid?
  end

  test "a post must have a linked user" do
    @micropost.user = nil
    assert_not @micropost.valid?
  end

  test "a micropost without content is invalid" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "a micropost has a maximum length of 140 characters" do
    @micropost.content = "message" * 150
    assert_not @micropost.valid?
  end

  test "microposts should be ordered, with the most recent appearing first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
