module ProfilesSessionsHelper
    def current_profile
        if (profile_id = session[:profile_id])
            @current_profile = Profile.find_by(id: profile_id)
        end
    end
    
    def current_profile_name
        current_profile ? current_profile.name : "None"
    end
end
