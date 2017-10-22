class StaticPagesController < ApplicationController
  include ParentmodeSessionsHelper, ProfilesSessionsHelper, TagsHelper, 
          SettingsHelper
  
  before_action :set_missing_defaults, only: [:home], :if => :user_signed_in?

  # Make sure that the other actions are opened in a new tab, otherwise
  # people will have to re-enter parent mode after viewing help
  before_action :exit_parent_mode, only: [:home]
  before_action :load_profiles, only: [:home]
  before_action :load_videos, only: [:home]
  
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
  
  private
  
    def set_missing_defaults
      set_all_profile_missing_defaults unless current_profile
    end
end
