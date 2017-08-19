class VideosController < ApplicationController
  before_action :logged_in_user, only: [:create, :update, :destroy]
  before_action :correct_profile, only: [:destroy, :update]
  
  def create
    if session[:profile_id]
      profile = get_profile(session[:profile_id])
      @video = profile.videos.build(video_params)
      if @video.save
        flash[:notice] = "Video saved"
        @videos = get_videos(profile, false, 6)
      else
        flash[:alert] = "Video not saved"
      end
    else
      flash[:alert] = "You must select a profile to save the video under"
    end
    redirect_back fallback_location: parent_path
  end

  def update
    if video_params["approved"]
      approved = (video_params["approved"] == 'true' ? true : false)
      if @video.update_attributes(approved: approved)
        flash[:action] = "Video approved"
      end
      redirect_back fallback_location: parent_path
    end
  end

  def destroy
    @video.destroy
    flash[:action] = "Video deleted"
    redirect_back fallback_location: parent_path
  end

  private
  
    def video_params
      params.require(:video).permit(:youtube_id, :approved)
    end
    
    def correct_profile
      @video = current_profile.videos.find_by(id: params[:id]) if current_profile
      redirect_to root_url if @video.nil?
    end
end
