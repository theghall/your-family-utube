class Video < ApplicationRecord
  include VideosHelper

  belongs_to :profile
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags
  default_scope -> { order(created_at: :desc) }
  mount_uploader :thumbnail, ThumbnailUploader
  before_validation :parse_id
  after_validation :set_thumbnail
  validates :youtube_id, presence: true, allow_blank: false
  validates :approved, inclusion: { in: [true, false] }
  validate :youtube_id, :valid_video_url
  after_save :save_tags

  attr_accessor :tag_names
  
  def tag_list
    tags.join(', ')
  end
    
  def tag_list=(tag_list)
    @tag_names = tag_list.split(',').collect{ |s| s.strip.downcase }.uniq
  end
  
  private
    
    def parse_id
      # Initially user enters a youtube URL
      self.youtube_id = parse_uri(self.youtube_id)
    end

    def valid_video_url
      video = Yt::Video.new(id: self.youtube_id)
      
      begin 
        video.title
      rescue Yt::Errors::NoItems
        errors[:base] << 'Thet YouTube Video cannot be found.'
      rescue Yt::Errors::RequestError
        errors[:base] << 'Unable to contact YouTube.  If problem persists contact us.'
      end
    end
    
    def set_thumbnail
      utube_video = Yt::Video.new(id: self.youtube_id)
      begin 
        self.remote_thumbnail_url = utube_video.thumbnail_url

      rescue Yt::Errors::RequestError
        # If youtube_id is for a valid video should not happen, but if so
        # default video thumbnail will be displayed.  parse_uri might have a bug.
      end

    end

    def save_tags
      return if tag_names.nil?

      profile = Profile.where(id: profile_id).first

      new_or_found_tags = tag_names.collect{ |name| Tag.find_or_create_by(user_id: profile.user_id, name: name) }

      self.tags = new_or_found_tags
    end

end
