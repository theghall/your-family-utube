class Setting < ApplicationRecord
  validates :name, presence: true
  validates_inclusion_of :default_value, :in => :allowed_values, if: :strict_values

end
