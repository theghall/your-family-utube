class StaticPagesController < ApplicationController
  include ParentmodeSessionsHelper, ProfilesSessionsHelper, TagsHelper, 
          SettingsHelper
  
  before_action :logged_in_user, only: [:parent]
  before_action :set_missing_defaults, only: [:home], :if => :user_signed_in?
  before_action :exit_parent_mode, except: [:parent]
  before_action :load_profiles, only: [:home, :parent]
  before_action :load_videos, only: [:home, :parent]
  
  def home
  end

  def help
  end

  def faq
  end

  def about
  end

  def contact
  end
  
  def parent
    profile = Profile.new
    
    @video = profile.videos.build
  end

  private
  
    def set_missing_defaults
      set_all_profile_missing_defaults unless current_profile
    end
end
