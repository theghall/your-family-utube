class Video < ApplicationRecord
  belongs_to :profile
  has_many :video_tags
  has_many :tags, through: :video_tags
end
