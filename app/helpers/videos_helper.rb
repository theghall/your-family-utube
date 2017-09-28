module VideosHelper
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

    def valid_youtube_video?(youtube_id)
      video = Yt::Video.new(id: youtube_id)
      
      valid = true

      begin 
        video.title
      rescue Yt::Errors::NoItems
        valid = false;
        flash.now[:alert] = 'That YouTube Video cannot be found.'
      rescue Yt::Errors::RequestError
        valid = false;
        flash.now[:alert] = 'Unable to contact YouTube.  If problem persists contact us.'
      end

      valid
    end
end
