require 'test_helper'

class StaticPageFlowTest < ActionDispatch::IntegrationTest
  test "should display help  page" do
    get help_path
    assert_response :success
  end

  test "should display FAQ page" do
    get faq_path
    assert_response :success
  end
end
