require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest

  test "should redirect create when not logged in" do
    assert_no_difference 'Profile.count' do
      post profiles_path, params: { profile: {name: "Jack" } }
      assert_redirected_to new_user_session_url
    end
  end
end
