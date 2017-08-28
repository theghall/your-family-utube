class VideosController < ApplicationController
  include ProfilesSessionsHelper
  
  before_action :logged_in_user, only: [:show, :create, :update, :destroy]
  before_action :correct_profile, only: [:show, :destroy, :update]
  
  def show
    set_curr_vid_url(get_video_url(@video))
    
    respond_to do |format|
      format.html { redirect_to (parent_mode? ? parent_path : root_url) }
      format.js
    end
  end
  
  def create
    if session[:profile_id]
      profile = get_profile(session[:profile_id])
      
      @video = profile.videos.build(video_params)
    
      # Get video thumbnail from YouTube  
      @video.remote_thumbnail_url = get_thumbnail(@video.youtube_id)
      
      if @video.save
        flash[:notice] = "Video saved"
        
        load_videos
      else
        flash[:alert] = "Video not saved"
      end
    else
      flash[:alert] = "You must select a profile to save the video under"
    end
    
    respond_to do |format|
      format.html { redirect_to parent_path }
      format.js
    end
  end

  def update
    if video_params["approved"]
      approved = (video_params["approved"] == 'true' ? true : false)
      
      if @video.update_attributes(approved: approved)
        flash[:action] = "Video approved"
        
        load_videos
        
        @videos.empty? ? set_curr_vid_url(nil) : set_curr_vid_url(get_video_url(@videos.first))
      end
      
      respond_to do |format|
        format.html { redirect_to parent_path }
        format.js
      end
    end
  end

  def destroy
    # Remove thumbnail file
    @video.remove_thumbnail
    
    @video.destroy
    
    flash[:action] = "Video deleted"
    
    load_videos

    @videos.empty? ? set_curr_vid_url(nil) : set_curr_vid_url(get_video_url(@videos.first))
    
    respond_to do |format|
      format.html { redirect_to parent_path }
      format.js
    end
  end

  private
  
    def video_params
      params.require(:video).permit(:youtube_id, :approved)
    end
    
    def correct_profile
      @video = current_profile.videos.find_by(id: params[:id]) if current_profile
      
      redirect_to root_url if @video.nil?
    end
    
    def get_thumbnail(youtube_id)
      video = Yt::Video.new(id: youtube_id)
      
      video.thumbnail_url
    end
end
