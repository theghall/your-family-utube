require 'test_helper'

class ProfilesInterfaceTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @user_no_profiles = users(:noprofiles)
    @user_no_videos = users(:novideos)
    @user_with_videos = users(:john)
    @pm_params = { parentmode: { pin: "1234"}}
  end
  
  test "profile interface with user with no profiles" do
    sign_in @user_no_profiles
    get root_path
    post parentmode_sessions_path, params: @pm_params
    follow_redirect!
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
     assert_no_match 'None', response.body
     assert_select 'div#vidframe', count: 0
    end
    
    test "profile with videos" do
     sign_in @user_with_videos
     get root_path
     # Choose profile
     @profile = profiles(:john_1)
     post profiles_sessions_path(name: @profile.name)
     follow_redirect!
     assert_no_match 'None', response.body
     assert_select 'div.vidframe', count: num_approved_videos(@profile)
    end
    
    test "add profie the ajax way" do
        name = "Jazzy"
        sign_in @user_with_videos
        get root_path
        post parentmode_sessions_path, params: @pm_params
        post profiles_path, params: { profiles: {name: name}}, xhr: true
        assert_match name, response.body
    end
    
    test "profile change the ajax way" do
        sign_in @user_with_videos
        get root_path
        #choose profile
        @profile = profiles(:john_1)
        post profiles_sessions_path(name: @profile.name), xhr: true
        assert_match @profile.name, response.body
        assert_match 'vidframe', response.body
    end
        
end
