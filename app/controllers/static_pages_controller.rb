class StaticPagesController < ApplicationController
  include ParentmodeSessionsHelper
  
  before_action :forget_parent
  
  def home
    if !current_user.nil?
      @profiles = current_user.profiles.all
      if session[:profile_id]
        profile = get_profile(session[:profile_id])
        @videos = get_videos(profile, true, 12)
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
