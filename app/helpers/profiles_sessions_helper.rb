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
      
    def load_videos
      if session[:profile_id]
        profile = get_profile(session[:profile_id])
        if parent_mode?
            @videos = get_videos(profile, false, 6)
        else
            @videos = get_videos(profile, true, 12)
        end
      end
    end
end
