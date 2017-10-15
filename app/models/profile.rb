class Profile < ApplicationRecord
  include SettingsHelper

  belongs_to :user
  has_many :profile_settings, dependent: :destroy
  has_many :settings, through: :profile_settings
  has_many :videos, dependent: :destroy
  validates :user_id, presence: true
  validates :name, presence: true, allow_blank: false,
            uniqueness: { scope: :user_id, message: "Profile name already taken" }
  after_save :set_profile_settings

  private
    def set_profile_settings
      set_profile_missing_defaults(id)
    end
end
