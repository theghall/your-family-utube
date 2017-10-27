require 'test_helper'

class ParentmodeSessionsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @youtube_url = "https://www.youtube.com/watch?v=Xm18dkRmDC8"
    @youtube_id = "Xm18dkRmDC8"
    @youtube_url2="https://youtu.be/SKRma7PDW10"
    @tags = "Tag1, Tag2"
    @tag1 = "tag1"
    @tag2 = "tag2"
    @user = users(:john)
    @profile = profiles(:john_1)
    @a_video= videos(:topgun)
    @user_no_videos = users(:novideos)
    @profile_no_videos = profiles(:novideos_1)
    @url1 = "https://www.youtube.com/watch?v=aT_3fHc0alA"
    @url2 = "https://www.youtube.com/watch?v=EIG0CJxJsic"
    @url3 = "https://www.youtube.com/watch?v=4CbmyFtICUU"
    @url4 = "https://www.youtube.com/watch?v=vzhqsWOTanw"
    @url5 = "https://www.youtube.com/watch?v=ABrIGGR8uRI"
    @url6 = "https://www.youtube.com/watch?v=A9L8xdatwYY"
    @free = account_types(:free)
    @unlimited = account_types(:unlimited)
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

    test "should display manage videos button and exit button" do
      sign_in @user
      get root_url
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      post profiles_sessions_path(name: @profile.name)
      assert_select 'form[action=?]', "#{parentmode_session_path(@user.id)}", 2
    end

    test "should display review videos button and exit button" do
      sign_in @user
      get root_url
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      post profiles_sessions_path(name: @profile.name)
      put parentmode_session_path(@user.id), params: { parentmode: { mode: 'review'}}
      follow_redirect!
      assert_select 'form[action=?]', "#{parentmode_session_path(@user.id)}", 2
    end

    test "Add video page only displays unapproved videos" do
     sign_in @user
     get root_path
     # Choose profile
     profile = profiles(:john_1)
     post profiles_sessions_path(name: profile.name)
     post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
     follow_redirect!
     assert_select 'div#vidframe', count: num_unapproved_videos(profile)
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
      assert session[:profile_id], profile.id
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
      assert_select 'input', id: 'video_youtube_id'
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: youtube_url }}
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
      
    test "should not allow a dupe youtube video per profile" do
      sign_in @user_no_videos
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = @profile_no_videos
      post profiles_sessions_path(name: profile.name)
      post videos_path params: { video: { youtube_id: @youtube_url, tag_list: @tags }}
      assert_no_difference 'Video.count' do
        post videos_path params: { video: { youtube_id: @youtube_url, tag_list: @tags }}
        assert_select 'div.alert', 1
      end
    end

    test "add video to a profile" do
      sign_in @user
      get root_path
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
      assert_match /#{@a_video.id}/, response.body
      assert_match @a_video.youtube_id, response.body
      patch video_path(@a_video), params: { video: { approved: 'true' }}
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
      assert_select 'a[href=?]', "#{video_path(@a_video.id)}", 0
    end
    
    test "adds video to review list ajax way" do
      youtube_url = "https://www.youtube.com/watch?v=YOI2r3Q-J3w"
      youtube_id = "YOI2r3Q-J3w"
      sign_in @user
      get root_path
      profile = profiles(:john_1)
      post profiles_sessions_path(name: profile.name)
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
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert session[:parent_id], @user.id
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
      end
      #search by those tags lowercase
      get videos_path params: { tags: { name: @tag1 }}
      assert_select 'div#vidframe', count: 1
      get videos_path params: { tags: { name: @tag2 }}
      assert_select 'div#vidframe', count: 1
      # search by an uppercase tag
      get videos_path params: { tags: { name: @tag1.upcase }}
      assert_select 'div#vidframe', count: 1
      # search by an invalid tag
      get videos_path params: { tags: { name: 'xxxxx' }}
      assert_not flash.empty?
     end 
     
     test "should clear search results" do
      sign_in @user_no_videos
      get root_path
      post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
      follow_redirect!
      profile = @profile_no_videos
      post profiles_sessions_path(name: profile.name)
      # Add video by tags
      assert_difference 'Tag.count', 2 do
        post videos_path params: { video: { youtube_id: @youtube_url, tag_list: @tags }}
      end
      # post a video with no tags
      post videos_path params: { video: { youtube_id: @youtube_url2 }}
      # search by tag
      get videos_path params: { tags: { name: @tag1 }}
      assert_select 'div#vidframe', count: 1
      # clear search
      get videos_path params: { tags: { name: '' }}
      assert_select 'div#vidframe', count: 2
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
     assert_template 'videos/index'
    end

    test "should not cancel account if not in parentmode" do
      sign_in @user
      get root_path
      assert_no_difference 'User.count' do
        get cancel_user_registration_path
      end
      assert_redirected_to root_url
    end

    test "should display videos to manage" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      put parentmode_session_path(@user.id), params: { parentmode: { mode: 'manage'}}
      follow_redirect!
      assert_select 'div#vidframe', num_approved_videos(@profile) 
    end

    test "should swith back to review mode" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      put parentmode_session_path(@user.id), params: { parentmode: { mode: 'manage'}}
      follow_redirect!
      assert_select 'div#vidframe', num_approved_videos(@profile) 
      put parentmode_session_path(@user.id), params: { parentmode: { mode: 'review'}}
      follow_redirect!
      assert_select 'div#vidframe', num_unapproved_videos(@profile) 
    end

    test "should not add video over max videos for limited account" do
      sign_in @user_no_videos
      get root_url
      @profile_no_videos.videos.destroy
      post profiles_sessions_path(name: @profile_no_videos.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url1 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url2 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url3 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url4 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url5 }}
      end
      assert_no_difference 'Video.count'  do
        post videos_path params: { video: { youtube_id: @url6 }}
      end
    end

    test "should add video when limited account switched to unlimited" do
      sign_in @user_no_videos
      get root_url
      @profile_no_videos.videos.destroy
      post profiles_sessions_path(name: @profile_no_videos.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url1 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url2 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url3 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url4 }}
      end
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url5 }}
      end
      assert_no_difference 'Video.count'  do
        post videos_path params: { video: { youtube_id: @url6 }}
      end
      # switch account types
      @user_no_videos.update_attribute(:account_type_id, @unlimited.id)
      @user_no_videos.save
      assert_difference 'Video.count',1  do
        post videos_path params: { video: { youtube_id: @url6 }}
      end
      # switch back
      @user_no_videos.update_attribute(:account_type_id, @free.id)
      @user_no_videos.save
    end

    test "should have clickable images in view and review modes" do
      sign_in @user
      get root_url
      v = @profile.videos.where(approved: true).first
      post profiles_sessions_path(name: @profile.name)
      assert_select 'a[href=?]', video_path(v.id), 1
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      post videos_path params: { video: { youtube_id: @url1 }}
      v = @profile.videos.where(approved: false).first
      # Delete is an href, so there should be 2 per video on this page
      assert_select 'a[href=?]', video_path(v.id), 2
    end

    test "should not have clickable images in manage mode" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      follow_redirect!
      post videos_path params: { video: { youtube_id: @url1 }}
      v = @profile.videos.where(approved: false).first
      put parentmode_session_path(@user.id), params: { parentmode: { mode: 'manage'}}
      follow_redirect!
      assert_select 'a[href=?]', video_path(v.id), 0
    end
end
