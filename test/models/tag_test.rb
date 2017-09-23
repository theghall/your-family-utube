require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = tags(:clip)
    @user = users(:john)
  end
  
  test "should be valid" do
    assert @tag.valid?
  end

  test "user_id should not be null" do
    @tag.user_id = nil
    assert_not @tag.valid?
  end
  
  test "name should not be blank" do
    @tag.name = " "
    assert_not @tag.valid?
  end

  test "should be unique per user" do
    Tag.create(user_id: @user.id,name: "Newtag");
    assert_raises ActiveRecord::RecordNotUnique do
      Tag.create(user_id: @user.id, name: "Newtag");
    end
  end
end
