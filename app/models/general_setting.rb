class GeneralSetting < ApplicationRecord
  belongs_to :setting
  validates :user_id, :setting_id, presence: true
end
