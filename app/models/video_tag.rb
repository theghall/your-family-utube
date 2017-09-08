class VideoTag < ApplicationRecord
  belongs_to :video
  belongs_to :tag
  before_save :got_ids
  
  private
  
    # When creating in Video#tags=, validates: presence: true fails as video_id
    # is nil at validation
    def got_ids
      throw(:abort) unless self.video_id && self.tag_id
    end
end
