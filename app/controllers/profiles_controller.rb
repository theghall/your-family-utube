class ProfilesController < ApplicationController
    before_action :logged_in_user, only: [:create]
    
    def create
        @profile = current_user.profiles.build(profiles_params)
        if @profile.save
            flash[:action] = "Profile saved!"
        else
            flash[:action] = "Profile not saved!"
        end
        redirect_to root_url
    end
    
    private
    
        def profiles_params
            params.require(:profiles).permit(:name)
        end
end
