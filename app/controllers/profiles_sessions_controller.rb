class ProfilesSessionsController < ApplicationController

  before_action :logged_in_user, only: [:create]
  
  def create
    session[:profile_id] = Profile.find_by(name: params[:name]).id
    load_videos

    @videos.empty? ? set_curr_vid_url(nil) : set_curr_vid_url(get_video_url(@videos.first))

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end
end
