require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(
      follower_id: users(:john_doe).id, followed_id: users(:jane_doe).id
    )
  end

  test "relationship with all attributes in valid state" do
    assert @relationship.valid?
  end

  test "relationship without a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "relationship without a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
