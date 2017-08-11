class Tag < ApplicationRecord
    has_many :video_tags
    has_many :videos, through: :video_tags
    validates :name, presence: true, allow_blank: false
end
