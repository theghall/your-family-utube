class ProfilesSessionsController < ApplicationController
  include VideosHelper

  before_action :logged_in_user, only: [:create]
  
  def create
    session[:profile_id] = Profile.find_by(name: params[:name]).id

    set_empty_video

    load_profiles

    load_videos

    respond_to do |format|
      format.html { render 'videos/index' }
      format.js
    end
  end
end
