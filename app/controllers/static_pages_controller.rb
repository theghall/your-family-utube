class StaticPagesController < ApplicationController
  def home
    if !current_user.nil?
      @profiles = current_user.profiles.all
      if session[:profile_id]
        profile = get_profile(session[:profile_id])
        @videos = get_approved_videos(profile)
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
  private
    def get_profile(id)
      Profile.find_by(id: id)
    end
      
    def get_approved_videos(profile)
        profile.videos.where(approved: true)
    end
    
    def num_approved_videos(profile)
        profile.videos.where(approved: true).count
    end
end
