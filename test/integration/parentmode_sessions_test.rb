require 'test_helper'

class ParentmodeSessionsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
    @profile = profiles(:john_1)
    @video= videos(:aliens)
  end
  
    test "only displays unapproved videos" do
     sign_in @user
     get root_path
     # Choose profile
     profile = profiles(:john_1)
     post profiles_sessions_path(name: profile.name)
     follow_redirect!
     assert_select 'div#video_list>ol>li>iframe', count: num_unapproved_videos(profile)
    end
    
    test "does not add a video when no profile selected" do
      sign_in @user
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      assert session[:parent_id], @user.id
      assert_select "div#add_video", count: 1
      assert_no_difference 'Video.count' do
        post video_path params: { video: { youtube_id: @video.youtube_id }}
      end
      assert_not flash.empty?
    end
    
    test "adds video to review list" do
      sign_in @user
      post parentmode_sessions_path, params: { parent: { pin: "1234" }}
      assert session[:parent_id], @user.id
      assert_select "div#add_video", count: 1
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      assert_difference 'Video.count',1  do
        post video_path params: { video: { youtube_id: @video.youtube_id }}
      end
      assigns(:avideo)
      assert flash.empty?
      follow_redirect!
      assert_match @youtube_id, body.response
      assigns(:videos).each do |v|
        assert_select 'a[href=?]', video_path(v.id), text: 'Approve'
        assert_select 'a[href=?]', video_path(v.id), text: 'delete'
      end
      patch video_path(avideo)
      follow_redirect!
      assert_no_match @video.youtube_id, body.response
    end
    
    test "add video to a profile" do
      sign_in @user
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      patch video_path(@video)
      follow_redirect!
      assert_no_match @video.youtube_id, body.response
    end
    
    test "delete a video from review list" do
      sign_in @user
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      delete video_path(@video)
      follow_redirect!
      assert_no_match @video.youtube_id, body.response
    end
      
      
end
