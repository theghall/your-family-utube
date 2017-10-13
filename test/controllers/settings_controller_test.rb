require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "settings page:should get redirected if not logged in," do
    get settings_path
    assert_redirected_to new_user_session_url
  end

  test "Settings update: :should get redirected if not logged in," do
    put setting_path(1)
    assert_redirected_to new_user_session_url
  end


end
