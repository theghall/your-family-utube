class Tag < ApplicationRecord
    belongs_to :user
    has_many :video_tags
    has_many :videos, through: :video_tags
    validates :user_id, presence: true
    validates :name, presence: true, allow_blank: false
    
    def to_s
        name
    end
end
