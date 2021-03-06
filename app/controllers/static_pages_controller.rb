class StaticPagesController < ApplicationController
  include ApplicationHelper, ParentmodeSessionsHelper, ProfilesSessionsHelper, TagsHelper, 
          SettingsHelper
  
  before_action :set_missing_defaults, only: [:home], :if => :user_signed_in?
  before_action :parent_user, only: [:parentfaq]
  # Make sure that the other actions are opened in a new tab, otherwise
  # people will have to re-enter parent mode after viewing help
  before_action :exit_parent_mode, only: [:home]
  before_action :load_profiles, only: [:home]
  before_action :load_videos, only: [:home]
  
  def home
    if user_signed_in?
      respond_to do |format|
        format.html { render 'videos/index' }
      end
    end
  end

  def help
  end

  def faq
  end

  def parentfaq
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  private

    def set_missing_defaults
      set_all_profile_missing_defaults unless current_profile
    end
end
