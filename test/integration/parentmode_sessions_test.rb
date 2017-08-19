require 'test_helper'

class ParentmodeSessionsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
    @profile = profiles(:john_1)
    @video= videos(:topgun)
  end
  
    test "Add video page only displays unapproved videos" do
     sign_in @user
     get root_path
     # Choose profile
     profile = profiles(:john_1)
     post profiles_sessions_path(name: profile.name)
     follow_redirect!
     post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
     follow_redirect!
     assert_template 'static_pages/parent'
     assert_select 'div.vidframe>iframe', count: num_unapproved_videos(profile)
    end
    
    test "does not add a video when no profile selected" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
      assert_no_difference 'Video.count' do
        post videos_path params: { video: { youtube_id: @video.youtube_id }}
        follow_redirect!
      end
      assert_not flash.empty?
    end
    
    test "adds video to review list" do
      youtube_id = "newvideo"
      sign_in @user
      get root_path
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      follow_redirect!
      assert session[:profile_id], profile.id
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
      assert_select 'input', id: 'video_youtube_id'
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: youtube_id }}
        follow_redirect!
      end
      assigns(:avideo)
      assert_not flash.empty?
      assert_match youtube_id, response.body
      assigns(:videos).each do |v|
        assert_select 'form[action=?]', video_path(v.id)
        assert_select 'a[href=?]', video_path(v.id), text: 'Delete'
      end
    end
    
    test "add video to a profile" do
      sign_in @user
      get root_path
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      follow_redirect!                  
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
      assert_template 'static_pages/parent'
      assert_match @video.youtube_id, response.body
      patch video_path(@video), params: { video: { approved: 'true' }}
      follow_redirect!
      assert_not flash.empty?
      assert_no_match @video.youtube_id, response.body
    end
    
    test "delete a video from review list" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      delete video_path(@video)
      follow_redirect!
      assert_no_match @video.youtube_id, response.body
    end
      
      
end
