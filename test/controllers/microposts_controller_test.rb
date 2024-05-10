require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:second_most_recent)
  end

  test "redirect non-logged-in users when they attempt to create microposts" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: "Test post"}}
    end
    assert_redirected_to login_url
  end

  test "redirect non-logged-in users when they attempt to delete microposts" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end
end
