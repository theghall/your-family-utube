class Video < ApplicationRecord
  belongs_to :profile
  has_many :video_tags
  has_many :tags, through: :video_tags
  default_scope -> { order(created_at: :desc) }
  mount_uploader :thumbnail, ThumbnailUploader
  validates :youtube_id, presence: true, allow_blank: false
  validates :approved, inclusion: { in: [true, false] }

end
