require 'test_helper'

class HomePageFlowTestTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
      @user = users(:john)
      @profiles = @user.profiles
    end


    test "should display link to get to parent mode" do
      sign_in @user
      get root_url
      assert_match new_parentmode_session_path, response.body
    end

    test "should display profile buttons" do
      sign_in @user
      get root_url
      @profiles.each do |p|
        assert_select 'form[action=?]', "#{profiles_sessions_path}?name=#{p.name}"
      end
    end
end
