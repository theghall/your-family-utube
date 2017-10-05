require 'test_helper'

class ProfileSettingTest < ActiveSupport::TestCase
  def setup
    @setting = profile_settings(:john_1_settings)
  end

  test 'it should be valid' do
    assert @setting.valid?
  end

  test 'user id should not be null' do
    @setting.user_id = ''
    assert_not @setting.valid?
  end

  test 'profile id should not be null' do
    @setting.profile_id = ''
    assert_not @setting.valid?
  end

  test 'setting id should not be null' do
    @setting.setting_id  = ''
    assert_not @setting.valid?
  end

  test 'should not allow dupe setting per profile' do
    @setting.save
    assert_no_difference 'ProfileSetting.count' do
      @setting.save
    end
  end
end
