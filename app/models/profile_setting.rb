class ProfileSetting < ApplicationRecord
  default_scope { order(profile_id: :asc, setting_id: :asc) }
  belongs_to :setting
  belongs_to :profile
  validates :profile_id, :setting_id, presence: true

  def self.controls_allowed?(profile)
    setting_id = Setting.where(name: 'Allow Controls').pluck(:id).first

    ProfileSetting.find_by(profile_id: profile.id, setting_id: setting_id).value == 'Yes'
  end

  def self.load_cc?(profile)
    setting_id = Setting.where(name: 'Video CC').pluck(:id).first

    ProfileSetting.find_by(profile_id: profile.id, setting_id: setting_id).value == 'On'

  end
end
