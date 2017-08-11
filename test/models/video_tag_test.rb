require 'test_helper'

class VideoTagTest < ActiveSupport::TestCase
  def setup
    @video_tag = video_tags(:alien_tag)
  end
  
  test "should be valid" do
    assert @video_tag.valid?
  end
  
  test "video_id should not be null" do
    @video_tag.video_id = nil
    assert_not @video_tag.valid?
  end
  
  test "tag_id should not be null" do
    @video_tag.tag_id = nil
    assert_not @video_tag.valid?
  end
end
