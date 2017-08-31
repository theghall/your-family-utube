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
     assert_select 'div.vidframe', count: num_unapproved_videos(profile)
    end
    
    test "does not add a video when no profile selected" do
      youtube_url = "https://www.youtube.com/watch?v=Qf869uQHYTk"
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
      assert_no_difference 'Video.count' do
        post videos_path params: { video: { youtube_id: youtube_url }}
        follow_redirect!
      end
      assert_not flash.empty?
    end
    
    test "adds video to review list" do
      youtube_url = "https://www.youtube.com/watch?v=Xm18dkRmDC8"
      youtube_id = "Xm18dkRmDC8"
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
        post videos_path params: { video: { youtube_id: youtube_url }}
        follow_redirect!
      end
      assert_not flash.empty?
      assert_match youtube_id, response.body
      assigns(:videos).each do |v|
        assert_select 'form[action=?]', video_path(v.id)
        assert_select 'a[href=?]', video_path(v.id), text: 'Delete'
      end
    end
    
    test 'Invalid youtube video not added' do
      youtube_url = "https://www.youtu.be/newvideo"
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
      assert_difference 'Video.count',0  do
        post videos_path params: { video: { youtube_id: youtube_url }}
      end
      assert_select 'div#error_explanation'
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
      assert_match /#{@video.id}/, response.body
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
    
    test "adds video to review list ajax way" do
      youtube_url = "https://www.youtube.com/watch?v=YOI2r3Q-J3w"
      youtube_id = "YOI2r3Q-J3w"
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
        post videos_path, params: { video: { youtube_id: youtube_url }}, xhr: true
      end
      assert_not flash.empty?
      assert_match youtube_id, response.body
    end
    
    test "add video to a profile ajax way" do
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
      patch video_path(@video), params: { video: { approved: 'true' }}, xhr: true
      assert_not flash.empty?
      assert_no_match @video.youtube_id, response.body
    end
    
    test "delete a video from review list ajax way" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name), xhr: true
      delete video_path(@video), xhr: true
      assert_no_match @video.youtube_id, response.body
    end
      
      
end
