class Video < ApplicationRecord
  belongs_to :profile
  has_many :video_tags
  has_many :tags, through: :video_tags
  default_scope -> { order(created_at: :desc) }
  mount_uploader :thumbnail, ThumbnailUploader
  before_validation :parse_id
  after_validation :set_thumbnail
  validates :youtube_id, presence: true, allow_blank: false
  validates :approved, inclusion: { in: [true, false] }
  validate :youtube_id, :valid_video_url
  
  def tag_list
    tags.join(', ')
  end
    
  def tag_list=(tag_list)
    tag_names = tag_list.split(',').collect{ |s| s.strip.downcase }.uniq
    
    new_or_found_tags = tag_names.collect{ |name| Tag.find_or_create_by(name: name) }
    
    self.tags = new_or_found_tags
  end
  
  private
    
    def parse_uri(uri)
      begin
        u = URI.parse uri
      rescue URI::InvalidURIError
        id = "invalid"
      else
        if u.path =~ /watch/
          id = CGI::parse(u.query)["v"].first
        else
          id = u.path
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
        errors[:base] << 'Youtube URL is not for a valid YouTube Video.'
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

end
