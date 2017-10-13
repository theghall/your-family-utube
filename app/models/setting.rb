class Setting < ApplicationRecord
  has_many :profile_settings, dependent: :destroy
  has_many :general_settings, dependent: :destroy
  validates :name, :setting_type, presence: true
  validates_inclusion_of :setting_type, :in => ['general','profile']
  validates_inclusion_of :default_value, :in => :allowed_values, if: :strict_values

end

