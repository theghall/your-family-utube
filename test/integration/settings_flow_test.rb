require 'test_helper'

class SettingsFlowTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
    @profiles = @user.profiles
    @profile1 = profiles(:john_1)
    @setting = settings(:anything)
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
    # 3 settings, 2 profiles missing settings
    assert_difference 'ProfileSetting.count', 6 do
      sign_in @user2
      get root_url
    end
  end

  test "should not throw error if profile has settings" do
    # 3 settings, 2 profiles missing settings
    assert_difference 'ProfileSetting.count', 6 do
      sign_in @user2
      get root_url
    end
    sign_out @user2
    sign_in @user2
    get root_url
  end

  test "should display settings for each profile" do
    sign_in @user
    get root_url
    post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
    follow_redirect!
    get settings_path
    assert_select 'label', {:html=>"Anything", :count=>@profiles.count}
    assert_select 'label', {:html=>"Allow controls", :count=>@profiles.count}
    assert_select 'label', {:html=>"Video cc", :count=>@profiles.count}
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

  test "should not require parent PIN to go back to parent mode from app settings" do
    sign_in @user
    get root_url
    post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
    follow_redirect!
    get settings_path
    get parent_path
    assert_template 'static_pages/parent'
  end

  test "should not require parent PIN to go back to parent mode from acct settings" do
    sign_in @user
    get root_url
    post parentmode_sessions_path, params: { parentmode: { pin: '1234' }}
    follow_redirect!
    get edit_user_registration_path
    get parent_path
    assert_template 'static_pages/parent'
  end

end
