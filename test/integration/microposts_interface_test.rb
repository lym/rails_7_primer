require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john_doe)
    log_in_as(@user)
  end
end

class MicropostsInterfaceTest < MicropostsInterface
  test "microposts pagination" do
    get root_path
    assert_select 'div.pagination'
  end

  test "invalid micropost submission" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: ''}}
    end
    assert_select 'div.field_with_errors'
    assert_select 'a[href=?]', '/?page=2'
  end

  test "valid micropost submission" do
    content = "A test micropost"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test "presence of micropost delete links on profile page" do
    get users_path(@user)
    assert_select 'a', text: 'delete'
  end

  test "deleting own micropost" do
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  test "presence of delete links on a different user's profile page" do
    get user_path(users(:jane_doe))
    assert_select 'a', {text: 'delete', count: 0}
  end
end
