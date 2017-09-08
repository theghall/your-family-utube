require 'test_helper'

class VideoTagTest < ActiveSupport::TestCase
  def setup
    @video_tag = video_tags(:alien_tag)
    @video_tag_new = VideoTag.new
  end
  
  test "should be valid" do
    assert @video_tag.valid?
  end
  
  test "video_id should not be null" do
    @video_tag_new.tag_id = 2
    assert_no_difference 'VideoTag.count' do
       @video_tag_new.save
    end
  end
  
  test "tag_id should not be null" do
    @video_tag_new.video_id = 2
    assert_no_difference 'VideoTag.count' do
       @video_tag_new.save
    end
  end
end
