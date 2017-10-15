require 'test_helper'

class UsersFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:john)
    @youtube_id = "Xm18dkRmDC8"
  end

  test "should not have any FK violations" do
    profile_name = 'somebody'
    sign_in @user
    get root_path
    post parentmode_sessions_path, params: { parentmode: { pin: "1234" }}
    # Ensure all tables are filled
    post profiles_path, params: {profiles: {name: profile_name}}
    post profiles_sessions_path(name: profile_name)
    post videos_path params: { video: { youtube_id: @youtube_url, tag_list: @tags }}
    sign_out @user
    assert_nothing_raised do
      assert_difference 'User.count', -1 do
        @user.destroy
      end
    end
  end
end
