require 'test_helper'

class VideosControllerTest < ActionDispatch::IntegrationTest
    def setup
        @video = videos(:aliens)
        @profile = profiles(:john_1)
    end
    
    test "should redirect create on not logged in" do
        post videos_path, params: { video: { youtube_id: 'xxxxxx' }}
        assert_redirected_to new_user_session_url
    end
    
    test "should redirect update on not logged in" do
        patch  video_path(@video)
        assert_redirected_to new_user_session_url
    end
    
    test "should redirect destroy on not logged in" do
        delete video_path(@video)
        assert_redirected_to new_user_session_url
    end
    
    test "should redirect index on not logged in" do
        get videos_path(@john_1)
        assert_redirected_to new_user_session_url
    end
end
