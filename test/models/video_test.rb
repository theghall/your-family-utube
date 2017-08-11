require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def setup
    @video = videos(:aliens)
  end
  
  test "should be valid" do
    assert @video.valid?
  end
  
  test "should not be blank" do
    @video.youtube_id = " "
    assert_not @video.valid?
  end
end
