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
    
    def load_videos
      if session[:profile_id]
        profile = get_profile(session[:profile_id])
        if parent_mode?
            @videos = get_videos(profile, false, 10)
        else
            @videos = get_videos(profile, true, 20)
        end
        
        curr_vid_url = (@videos.nil? ? nil : get_video_url(@videos.first))
        
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
