require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  
  test "should redirect index on not logged in" do
    get tags_path
    assert_redirected_to new_user_session_url
  end
end
