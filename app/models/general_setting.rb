class GeneralSetting < ApplicationRecord
  validates :user_id, :setting_id, presence: true
end
