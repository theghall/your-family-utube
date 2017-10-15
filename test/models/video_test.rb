require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def setup
    @valid_video = videos(:aliens)
    @invalid_video = videos(:invalid)
  end
  
  test "should be valid" do
    assert @valid_video.valid?
  end
  
  test "should have video attibutes" do
    video = Video.new(youtube_id: @valid_video.youtube_id)
    video.save
    assert_not_equal video.thumbnail_url, 'missing.jpg'
    assert_not video.title.nil?
  end
  
  test "should not be blank" do
    @valid_video.youtube_id = " "
    assert_not @valid_video.valid?
  end
  
  test "should not be valid with an invalid YouTube video" do
    assert_not @invalid_video.valid?
  end
end
