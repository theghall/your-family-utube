require 'test_helper'

class ParentmodeSessionsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @youtube_url = "https://www.youtube.com/watch?v=Xm18dkRmDC8"
    @youtube_id = "Xm18dkRmDC8"
    @tags = "Tag1, Tag2"
    @tag1 = "tag1"
    @tag2 = "tag2"
    @user = users(:john)
    @profile = profiles(:john_1)
    @a_video= videos(:topgun)
    @user_no_videos = users(:jack)
    @profile_no_videos = profiles(:jack_1)
  end
  
    test "should redirect if try to add profile directly" do
      sign_in @user
      get root_path
      assert_no_difference 'Profile.count' do
        post profiles_path, params: {profiles: {name: 'somebody'}}
      end
      assert_redirected_to root_path
    end

    test "should redirect if try to add a video directly" do
      youtube_url = "https://www.youtube.com/watch?v=Qf869uQHYTk"
      sign_in @user
      get root_path
      assert_no_difference 'Video.count' do
        post videos_path params: { video: { youtube_id: youtube_url }}
      end
      assert_redirected_to root_url
    end

    test "should redirect if try to approve a video directly" do
      sign_in @user
      get root_path
      patch video_path(@a_video), params: { video: { approved: 'true' }}
      assert_redirected_to root_path
      @a_video.reload
      assert '@a_video.approved', false
    end

    test "should redirect if try to access user account settings dirctrly" do
      sign_in @user
      get root_path
      get edit_user_registration_path
      assert_redirected_to root_path
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
      assert_match /#{@a_video.id}/, response.body
      assert_match @a_video.youtube_id, response.body
      patch video_path(@a_video), params: { video: { approved: 'true' }}
      follow_redirect!
      assert_not flash.empty?
      assert_no_match @a_video.youtube_id, response.body
    end

    test "adds video to review list with short video URL" do
      youtube_url = "https://youtu.be/3sFw5Mt70vY"
      youtube_id = "3sFw5Mt70vY"
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

    test "adds video to review list with just id" do
      youtube_url = "sHZ8RYT8bgM"
      youtube_id = "sHZ8RYT8bgM"
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
    
    test "delete a video from review list" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      delete video_path(@a_video)
      follow_redirect!
      assert_no_match @a_video.youtube_id, response.body
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
      assert_match @a_video.youtube_id, response.body
      patch video_path(@a_video), params: { video: { approved: 'true' }}, xhr: true
      assert_not flash.empty?
      assert_no_match @a_video.youtube_id, response.body
    end
    
    test "delete a video from review list ajax way" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name), xhr: true
      delete video_path(@a_video), xhr: true
      assert_no_match @a_video.youtube_id, response.body
    end
      
    test "should add tags" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      # Add video by tags
      assert_difference 'Tag.count', 2 do
        post videos_path params: { video: { youtube_id: @youtube_url, tag_list: @tags }}
        follow_redirect!
      end
      #search by those tags lowercase
      get videos_path params: { tags: { name: @tag1 }}
      follow_redirect!
      assert_select 'div.vidframe', count: 1
      get videos_path params: { tags: { name: @tag2 }}
      follow_redirect!
      assert_select 'div.vidframe', count: 1
      # search by an uppercase tag
      get videos_path params: { tags: { name: @tag1.upcase }}
      follow_redirect!
      assert_select 'div.vidframe', count: 1
      # search by an invalid tag
      get videos_path params: { tags: { name: 'xxxxx' }}
      follow_redirect!
      assert_not flash.empty?
     end 
     
     test "clear search results" do
      sign_in @user_no_videos
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = @profile_no_videos
      post profiles_sessions_path(name: profile.name)
      # Add video by tags
      assert_difference 'Tag.count', 2 do
        post videos_path params: { video: { youtube_id: @youtube_url, tag_list: @tags }}
        follow_redirect!
      end
      # post a video with no tags
      post videos_path params: { video: { youtube_id: @youtube_url }}
      follow_redirect!
      # search by tag
      get videos_path params: { tags: { name: @tag1 }}
      follow_redirect!
      assert_select 'div.vidframe', count: 1
      # clear search
      get videos_path params: { tags: { name: '' }}
      follow_redirect!
      assert_select 'div.vidframe', count: 2
    end

    test "should show error on invlid PIN" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '0000' }}
      assert_not flash.empty?
    end

    test "should show error on invlid password" do
      sign_in @user
      get root_path
      post parentmode_sessions_path, params: { parentmode: { password: 'invalid' }}
      assert_not flash.empty?
    end

    test "should enter parent mode with password" do
     sign_in @user
     get root_path
     post parentmode_sessions_path, params: { parentmode: { password: "password" }}
     follow_redirect!
     assert_template 'static_pages/parent'
    end

    test "should not cancel account if not in parentmode" do
      sign_in @user
      get root_path
      assert_no_difference 'User.count' do
        get cancel_user_registration_path
      end
      assert_redirected_to root_url
    end
end
