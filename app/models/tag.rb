class Tag < ApplicationRecord
    belongs_to :user
    has_many :video_tags
    has_many :videos, through: :video_tags
    validates :user_id, presence: true
    validates :name, presence: true, allow_blank: false
    
    def to_s
        name
    end

    def self.search(userid, key, approved)
      approved_literal = approved ? 'TRUE' : 'FALSE'

      where('user_id = :userid AND name LIKE :key AND approved = :approved', userid: userid, key: "%#{key.downcase}%", approved: approved_literal);
    end
end
