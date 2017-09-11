class ProfilesController < ApplicationController
    before_action :logged_in_user, only: [:create]
    
    def create
        @profile = current_user.profiles.build(profiles_params)
        if @profile.save
            flash[:notice] = "Profile saved!"
        else
            flash[:alert] = "Profile not saved!"
        end
        
        load_profiles
        
        respond_to do |format|
            format.html { redirect_back fallback_location: root_url }
            format.js
        end
    end
    
    private
    
        def profiles_params
            params.require(:profiles).permit(:name)
        end
end
