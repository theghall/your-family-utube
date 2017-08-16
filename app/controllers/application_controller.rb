class ApplicationController < ActionController::Base
  include ProfilesSessionsHelper, ParentmodeSessionsHelper
    # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
    private
  
    def logged_in_user
      unless user_signed_in?
        flash[:alert] = "Please Signin"
        redirect_to new_user_session_url
      end
    end
    
    def get_profile(id)
      Profile.find_by(id: id)
    end
    
    def get_videos(profile, approved, per_page)
        profile.videos.where(approved: approved).paginate(page: params[:page], per_page: per_page)
    end
    
    def num_videos(profile, approved)
        profile.videos.where(approved: approved).count
    end

end
