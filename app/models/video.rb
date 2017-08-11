class Video < ApplicationRecord
  belongs_to :profile
  has_many :video_tags
  has_many :tags, through: :video_tags
  validates :youtube_id, presence: true, allow_blank: false
  validates :approved, presence: true, inclusion: { in: [true, false] }
end
