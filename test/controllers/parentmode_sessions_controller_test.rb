require 'test_helper'

class ParentmodeSessionsControllerTest < ActionDispatch::IntegrationTest
  
  test "should redirect when not logged in" do
    post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
    assert_redirected_to new_user_session_url
  end
end
