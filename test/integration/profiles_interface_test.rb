require 'test_helper'

class ProfilesInterfaceTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @user_no_profiles = users(:noprofiles)
    @user_no_videos = users(:novideos)
    @user_with_videos = users(:john)
  end
  
  test "profile interface with user with no profiles" do
    sign_in @user_no_profiles
    get root_path
    assert_match "No Profiles", response.body 
    # Invalid profile name
    assert_no_difference 'Profile.count' do
        post profiles_path, params: { profiles: { name: "  " } }
    end
    # Add a profile
    name = "Junior"
    assert_difference 'Profile.count', 1 do
        post profiles_path, params: { profiles: { name: name } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'li', text: name, count: 1
    # select profile
    post profiles_sessions_path(name: name)
    assert_equal session[:profile_id], get_profile_id(name)
  end
  
  test "profile with no videos" do
    sign_in @user_no_videos
     get root_path
     # Choose profile
     profile = profiles(:novideos_1)
     post profiles_sessions_path(name: profile.name)
     follow_redirect!
     assert_select 'div#video_list>ol>li>iframe', count: 0
    end
    
    test "profile with videos" do
     sign_in @user_with_videos
     get root_path
     # Choose profile
     profile = profiles(:john_1)
     post profiles_sessions_path(name: profile.name)
     follow_redirect!
     assert_select 'div#video_list>ol>li>iframe', count: num_approved_videos(profile)
    end
  
end
