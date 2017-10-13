class ProfileSetting < ApplicationRecord
  default_scope { order(profile_id: :asc, setting_id: :asc) }
  belongs_to :setting
  belongs_to :profile
  validates :profile_id, :setting_id, presence: true
end
