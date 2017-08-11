class Profile < ApplicationRecord
  belongs_to :user
  has_many :videos
  validates :user_id, presence: true
  validates :name, presence: true, allow_blank: false,
            uniqueness: { scope: :user_id, message: "Profile name already taken" }
end
