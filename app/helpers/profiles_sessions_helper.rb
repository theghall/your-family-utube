module ProfilesSessionsHelper
    
    def current_profile
        session[:profile_id].nil? ? "None" : Profile.find_by(id: session[:profile_id]).name
    end
end
