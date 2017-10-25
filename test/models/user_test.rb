require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:john)
  end

  test "should not allow blank pin" do
    @user.pin = ' '
    @user.pin_confirmation = ' '
    @user.parent_digest = ""
    assert_not @user.valid?
  end

  test "should not allow pin/pin_confirmation to be different" do
    @user.pin = "1234"
    @user.pin_confirmation = "2345"
    @user.parent_digest = ""
    assert_not @user.valid?
  end

  test "should not allow a 3 character pin" do
    @user.pin = "123"
    @user.pin_confirmation = "123"
    @user.parent_digest = ""
    assert_not @user.valid?
  end

  test "should not allow a 5 character pin" do
    @user.pin = "12345"
    @user.pin_confirmation = "12345"
    @user.parent_digest = ""
    assert_not @user.valid?
  end

  test "should not validate if pin/pin confimation blank and there is a pin digest" do
    @user.pin=''
    @user.pin_confirmation = ''
    assert @user.valid?
  end

end
