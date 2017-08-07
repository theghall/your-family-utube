require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @user = users(:noprofiles)
    @profile = @user.profiles.build(name: "Junior")
  end
  
  test "should be valid" do
    assert @profile.valid?
  end
  
  test "user_id should be present" do
    @profile.user_id = nil
    assert_not @profile.valid?
  end
    
  test "name should be present" do
    @profile.name = nil
    assert_not @profile.valid?
  end
  
  test "name cannot be blank" do
    @profile.name = " "
    assert_not @profile.valid?
  end
  
end
