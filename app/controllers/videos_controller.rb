class VideosController < ApplicationController
  include ProfilesSessionsHelper, TagsHelper,VideosHelper
  
  before_action :handle_reset, only: [:create]
  before_action :logged_in_user, only: [:show, :create, :update, :destroy]
  before_action :correct_profile, only: [:show, :destroy, :update]
  
  def show
    set_curr_vid_url(get_video_url(@video))
    
    respond_to do |format|
      format.html { redirect_to (parent_mode? ? parent_path : root_url) }
      format.js
    end
  end

  def preload
    params = video_params

    if valid_youtube_video?(parse_uri(params['youtube_id'])) 
      set_curr_vid_url(make_video_url(parse_uri(params['youtube_id'])))
    end

    respond_to do |format|
      format.html { redirect_to (parent_mode? ? parent_path : root_url) }
      format.js
    end
  end
  
  def create
    if session[:profile_id]
      profile = get_profile(session[:profile_id])
      
      @video = profile.videos.build(video_params)
      
      if @video.save
        flash[:notice] = "Video saved"
        
        clear_search_key
        
        load_videos
        
        respond_to do |format|
          format.html { redirect_to parent_path }
          format.js
        end
      else
        load_profiles
        
        load_videos
        
        respond_to do |format|
          format.html { render 'static_pages/parent' }
          format.js
        end
      end
    else
      flash[:alert] = "You must select a profile to save the video under"
      
      load_profiles

      respond_to do |format|
         format.html { render 'static_pages/parent' }
         format.js
      end
    end
  end

  def update

    if video_params["approved"]
      approved = (video_params["approved"] == 'true' ? true : false)
      
      if @video.update_attributes(approved: approved)
        flash[:notice] = "Video approved"
        
        clear_search_key if num_video_by_search_key(false) == 1
        
        load_videos
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
    
    flash[:notice] = "Video deleted"
    
    clear_search_key if num_video_by_search_key(false) == 1
    
    load_videos
    
    respond_to do |format|
      format.html { redirect_to parent_path }
      format.js
    end
  end

  private
  
    def video_params
      params.require(:video).permit(:youtube_id, :approved, :tag_list)
    end
    
    def correct_profile
      @video = current_profile.videos.find_by(id: params[:id]) if current_profile
      
      redirect_to root_url if @video.nil?
    end

    def handle_reset
      if params[:reset]
        load_videos

        respond_to do |format|
          format.html { redirect_to parent_path }
          format.js { render :template => 'videos/create.js.erb' }
        end
      end
    end
end
