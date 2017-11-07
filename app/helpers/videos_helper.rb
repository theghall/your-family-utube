module VideosHelper

    def set_empty_video
      p = Profile.new

      @video = p.videos.build
    end

    def parse_uri(uri)
      # Let Google API determine valid id
      begin
        u = URI.parse uri
      rescue URI::InvalidURIError
        id = "invalid"
      else
        if u.path =~ /watch/
          id = CGI::parse(u.query)["v"].first
        elsif u.path[0] == '/'
          id = u.path[1..-1]
        else
          # If just an id is passed in this will catch it
          id = u.path
        end
      end
    end

    def video_status(youtube_id)
      video = Yt::Video.new(id: youtube_id)
      
      status = ''

      begin 
        video.title
      rescue Yt::Errors::NoItems
        status = 'That YouTube Video cannot be found.'
      rescue Yt::Errors::RequestError
        status = 'Unable to contact YouTube.  If problem persists contact us.'
      end

      if status.empty? && !video.embeddable?
        status = 'The video owner has disabled embedding of that video.'
      end

      status
    end

    def valid_youtube_video?(youtube_id)
      valid = true

      status = video_status(youtube_id)

      if !status.empty?
        flash.now[:alert] = status

        valid = false
      end

      valid
    end

    def get_video_title(youtube_id)
      video = Yt::Video.new(id: youtube_id)

      begin
        video.title
      rescue Yt::Errors::RequestError
        ''
      end
    end
end
