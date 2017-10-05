class ProfileSetting < ApplicationRecord
  validates :user_id, :profile_id, :setting_id, presence: true
end
