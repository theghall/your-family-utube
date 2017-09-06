module ProfilesSessionsHelper
    def current_profile
        if (profile_id = session[:profile_id])
            @current_profile = Profile.find_by(id: profile_id)
        end
    end
    
    def current_profile_name
        current_profile ? current_profile.name : "None"
    end
    
    def load_profiles
        @profiles = current_user.profiles.all unless current_user.nil?
    end

    def get_video_url(video) 
        "https://www.youtube.com/embed/" + video.youtube_id + "?rel=0&controls=0"
    end
    
    def refresh_thumbnails(pvideos)
        
        no_thumb = pvideos.where(thumbnail: nil)

        no_thumb.each do |v|
            utube_video = Yt::Video.new(id: v.youtube_id)
            
            refresh = true
            
            begin
                thumbnail_url = utube_video.thumbnail_url
            rescue Yt::Errors::RequestError
                # Model should catch invalid YouTube videos.
                # Otherwise API Key invalid, API error, video removed or
                # the restriction on the API key needs to be updated
                # in Google Console
                refresh = false
            end
            
            if refresh
                v.remote_thumbnail_url = thumbnail_url
                
                v.save
            end
        end
    end
    def load_videos
      if session[:profile_id]
        profile = get_profile(session[:profile_id])
        if parent_mode?
            @videos = get_videos(profile, false, 10)
        else
            @videos = get_videos(profile, true, 20)
        end
        
        refresh_thumbnails(@videos)
 
        curr_vid_url = (@videos.empty? ? nil : get_video_url(@videos.first))
        
        set_curr_vid_url(curr_vid_url)
      end
    end
    
    def set_curr_vid_url(url)
        session[:curr_vid_url] = url
    end
    
    def curr_vid_url
        session[:curr_vid_url]
    end
end
