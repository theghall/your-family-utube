require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = tags(:clip)
  end
  
  test "should be valid" do
    assert @tag.valid?
  end
  
  test "should not be blank" do
    @tag.name = " "
    assert_not @tag.valid?
  end
end
