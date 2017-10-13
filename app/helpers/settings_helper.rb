module SettingsHelper

  def strict_values(setting_id)
    Setting.find(setting_id).strict_values
  end

  def setting_options(setting_id)
    Setting.find(setting_id).allowed_values.gsub(' ','').split(',')
  end

  def get_profile_settings(profile_id)
    Profile.find(profile_id).profile_settings
  end

  def set_profile_missing_defaults(profile_id)
    settings = get_profile_settings(profile_id)

    # Get missing settings
    missing = Setting.select(:id, :default_value).where(setting_type: 'profile').where.not(id: settings.map(&:setting_id))

    missing.each do |m|
      ProfileSetting.create(profile_id: profile_id, setting_id: m.id, value: m.default_value)
    end
  end

  def set_all_profile_missing_defaults
    profiles = User.find(current_user.id).profiles

    profiles.each do |p|
      set_profile_missing_defaults(p.id)
    end
  end
end
