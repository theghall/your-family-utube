require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def setup
    @setting = settings(:allow_control)
    @strict_setting = settings(:allow_control)
    @nonstrict_setting = settings(:anything)
  end

  test 'it should be valid' do
    assert @setting.valid?
  end  

  test 'it should not allow name null value' do
    @setting.name = ''
    assert_not @setting.valid?
  end

  test 'it should not allow type null value' do
    @setting.setting_type = ''
    assert_not @setting.valid?
  end

  test 'it should allow profile as type' do
    @setting.setting_type = 'profile'
    assert @setting.valid?
  end

  test 'it should allow general as type' do
    @setting.setting_type = 'general'
    assert @setting.valid?
  end

  test 'it should not allow duplicate value' do
    @setting.save
    assert_no_difference 'Setting.count' do
      @setting.save
    end
  end

  test 'when strict values, it should not allow illegl value' do
    @strict_setting.default_value = 'invalid'
    assert_not @setting.valid?
  end

  test 'when non-strict values, it should allow any value' do
    @nonstrict_setting.default_value = 'anything'
    assert @nonstrict_setting.valid?
  end
end
