require 'test_helper'

class SettingsFlowTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
    @profile1 = profiles(:john_1)
    @setting = Setting.second
    @profile1_setting = profile_settings(:john_1_anything_setting)
    @setting_params = {settings: {profiles: [{profile_id: @profile1.id.to_s, setting_id: @setting.id.to_s, value: 'changed'}]}}
    @user2 = users(:jack)
  end

  test 'should redirect to home if try to access settings directly' do
    sign_in @user
    get root_url
    get settings_path
    assert_redirected_to root_url
  end

  test 'should redirect to home if try to update settings directly' do
    sign_in @user
    get root_url
    put setting_path(@user.id), params: @setting_params
    assert_redirected_to root_url
  end

  test "should create missing settings" do
    # 2 settings, 2 profiles missing settings
    assert_difference 'ProfileSetting.count', 4 do
      sign_in @user2
      get root_url
    end
  end

  test "should not throw error if profile has settings" do
    # 2 settings, 2 profiles missing settings
    assert_difference 'ProfileSetting.count', 4 do
      sign_in @user2
      get root_url
    end
    sign_out @user2
    sign_in @user2
    get root_url
  end

  test "should update record" do
    sign_in @user
    get root_url
    post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
    follow_redirect!
    get settings_path
    assert_template 'settings/index'
    original_value = @profile1_setting.value
    put setting_path(@user.id), params: @setting_params
    follow_redirect!
    assert_not flash[:notice].empty?
    @profile1_setting.reload
    assert_not_equal original_value, @profile1_setting.value
  end

end
