require 'test_helper'

class GeneralSettingTest < ActiveSupport::TestCase

  def setup
    @setting =  general_settings(:john_settings)
  end

  test 'it should be valid' do
    assert @setting.valid?
  end

  test 'user_id should not be null' do
    @setting.user_id = ''
    assert_not @setting.valid?
  end

  test 'setting_id should not be null' do
    @setting.setting_id = ''
    assert_not @setting.valid?
  end

  test 'it should not allow dupe setting per user id' do
    @setting.save
    assert_no_difference 'GeneralSetting.count' do
      @setting.save
    end
  end

end
