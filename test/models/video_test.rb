require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def setup
    @valid_video = videos(:aliens)
    @invalid_video = videos(:invalid)
  end
  
  test "should be valid" do
    assert @valid_video.valid?
  end
  
  test "thumbnail shoud not be missing for valid video" do
    @valid_video.save
    assert_not_equal @valid_video.thumbnail_url, 'missing.jpg'
  end
  
  test "should not be blank" do
    @valid_video.youtube_id = " "
    assert_not @valid_video.valid?
  end
  
  test "should not be valid with an invalid YouTube video" do
    assert_not @invalid_video.valid?
  end
end
