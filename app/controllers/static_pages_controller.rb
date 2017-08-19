class StaticPagesController < ApplicationController
  include ParentmodeSessionsHelper
  
  before_action :forget_parent, except: [:parent]
  before_action :set_profiles, only: [:home, :parent]
  
  def home
      load_videos(true, 12)
  end

  def help
  end

  def about
  end

  def contact
  end
  
  def parent
     load_videos(false, 6)
  end
  
  private
    def set_profiles
      if !current_user.nil?
        @profiles = current_user.profiles.all
      end
    end
    
    def load_videos(approved, per_page)
      if session[:profile_id]
        profile = get_profile(session[:profile_id])
        @videos = get_videos(profile, approved, per_page)
      end
    end
    
end
