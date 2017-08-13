require 'test_helper'

class ProfilesSessionsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @profile = profiles(:john_1)
    end
    
    test "should redirect create on not logged in" do
        post profiles_sessions_path(@profile.name)
        assert_redirected_to new_user_session_url
    end
end
