require 'test_helper'

class VideosFlowTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers


    def setup
      @user = users(:john)
      @profile = profiles(:john_1)
      @controls_setting=settings(:allow_control)
      @cc_setting=settings(:show_cc)
      @controls_on_params = {settings: {profiles: [{profile_id: @profile.id.to_s, setting_id: @controls_setting.id.to_s, value: 'Yes'}]}}
      @controls_off_params = {settings: {profiles: [{profile_id: @profile.id.to_s, setting_id: @controls_setting.id.to_s, value: 'No'}]}}
      @cc_on_params = {settings: {profiles: [{profile_id: @profile.id.to_s, setting_id: @cc_setting.id.to_s, value: 'On'}]}}
      @cc_off_params = {settings: {profiles: [{profile_id: @profile.id.to_s, setting_id: @cc_setting.id.to_s, value: 'Off'}]}}
    end

    test "should not display controls if profile setting 'No'" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      put setting_path(@user.id), params: @controls_off_params
      get root_url
      assert_includes response.body, 'controls=0'
    end

    test "should display controls if profile setting 'Yes'" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      put setting_path(@user.id), params: @controls_on_params
      get root_url
      assert_not_includes response.body, 'controls=0'
    end

    test "should not show CC if profile setting 'No'" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      put setting_path(@user.id), params: @cc_off_params
      get root_url
      assert_not_includes response.body, 'cc_load_policy=1'
    end

    test "should not show CC if profile setting 'Yes'" do
      sign_in @user
      get root_url
      post profiles_sessions_path(name: @profile.name)
      post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
      put setting_path(@user.id), params: @cc_on_params
      get root_url
      assert_includes response.body, 'cc_load_policy=1'
    end
end
