class Video < ApplicationRecord
  include VideosHelper

  belongs_to :profile
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags
  default_scope -> { order(created_at: :desc) }
  mount_uploader :thumbnail, ThumbnailUploader
  before_validation :max_videos
  before_validation :parse_id
  after_validation :set_video_attributes
  validates :youtube_id, presence: true, allow_blank: false,
            uniqueness: { scope: :profile_id, message: "This profile already has this video" }
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
   
    def max_videos
      user_id = Profile.user_id(self.profile_id)

      user = User.find_by(id: user_id)

      if AccountType.has_limit(user.account_type_id)
        max_videos = AccountType.limit(user.account_type_id)

        profile = Profile.find_by(id: self.profile_id)

        if profile.videos.count + 1 > max_videos
          errors[:base] << 'You have reached the maximum number of videos allowed.'
        end
      end
    end 

    def parse_id
      # Initially user enters a youtube URL
      self.youtube_id = parse_uri(self.youtube_id)
    end

    def valid_video_url
      video = Yt::Video.new(id: self.youtube_id)
      
      begin 
        video.title
      rescue Yt::Errors::NoItems
        errors[:base] << 'That YouTube Video cannot be found.'
      rescue Yt::Errors::RequestError
        errors[:base] << 'Unable to contact YouTube.  If problem persists contact us.'
      end
    end
    
    def set_thumbnail(utube_video)
      begin 
        self.remote_thumbnail_url = utube_video.thumbnail_url

      rescue Yt::Errors::RequestError
        # If youtube_id is for a valid video should not happen, but if so
        # default video thumbnail will be displayed.  parse_uri might have a bug.
      end

    end

    def set_title(utube_video)
      begin
        self.title = utube_video.title.gsub("\"",'')
      rescue Yt::Errors::RequestError
        # If youtube_id is for a valid video should not happen, but if so
        # we will give a default title.  parse_uri might have a bug.
        self.title = 'Unknown'
      end

    end

    def set_has_cc(utube_video)
      begin
        self.has_cc = utube_video.captioned?
      rescue Yt::Errors::RequestError
        # If youtube_id is for a valid video should not happen, but if so
        # we will assume false for CC.  parse_uri might have a bug.
        self.has_cc = false

      end
    end

    def set_video_attributes
      utube_video = Yt::Video.new(id: self.youtube_id)

      set_thumbnail(utube_video)
      set_title(utube_video)
      set_has_cc(utube_video)

    end

    def save_tags
      return if tag_names.nil?

      profile = Profile.where(id: profile_id).first

      new_or_found_tags = tag_names.collect{ |name| Tag.find_or_create_by(user_id: profile.user_id, name: name) }

      self.tags = new_or_found_tags
    end

end
