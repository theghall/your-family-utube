require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @user = users(:noprofiles)
    @other_user = users(:john)
    @profile = @user.profiles.create(name: "Junior")
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
  
  test "Duplicate profile name per user disallowed" do
    assert_no_difference 'Profile.count' do
      @user.profiles.create(name: "Junior")
    end
  end
  
  test "Existing profile name under one user allowed under other user" do
    assert_difference 'Profile.count', 1 do
      @other_user.profiles.create(name: "Junior")
    end
  end
end
