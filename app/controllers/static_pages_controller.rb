class StaticPagesController < ApplicationController
  include ParentmodeSessionsHelper, ProfilesSessionsHelper
  
  before_action :forget_parent, except: [:parent]
  before_action :load_profiles, only: [:home, :parent]
  before_action :load_videos, only: [:home, :parent]
  
  def home
  end

  def help
  end

  def about
  end

  def contact
  end
  
  def parent
    profile = Profile.new
    
    @video = profile.videos.build
  end
  
end
