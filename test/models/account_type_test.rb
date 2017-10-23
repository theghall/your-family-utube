require 'test_helper'

class AccountTypeTest < ActiveSupport::TestCase

  def setup
    @free = account_types(:free)
    @unlimited = account_types(:unlimited)
  end

  test "should be valid" do
    assert @free.valid?
    assert @unlimited.valid?
  end

  test "name should not be empty" do
    @free.name = ''
    assert_not @free.valid?
  end

  test "video_limit should not be null" do
    @free.video_limit = nil
    assert_not @free.valid?
  end

  test "num videos should not be zero" do
    @free.num_videos = 0
    assert_not @free.valid?
  end

  test "num videos should not be less than zero" do
    @free.num_videos = -1
    assert_not @free.valid?
  end

end
