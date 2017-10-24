class VideosController < ApplicationController
  include ApplicationHelper, ProfilesSessionsHelper, TagsHelper,VideosHelper
  
  before_action :handle_reset, only: [:create]
  before_action :logged_in_user, only: [:show, :index, :create, :update, :destroy]
  before_action :parent_user, only: [:create, :update, :destroy]
  before_action :correct_profile, only: [:show, :destroy, :update]
  
  def show
    load_profiles

    set_curr_vid_url(get_video_url(@video))
    
    respond_to do |format|
      format.html {
        if parent_mode?
          render 'videos/index'
        else
          redirect_to root_url
        end
      }
      format.js
    end
  end

  def preload
    params = video_params

    if session[:profile_id]
      if valid_youtube_video?(parse_uri(params['youtube_id'])) 
       set_curr_vid_url(make_video_url(parse_uri(params['youtube_id'])))
      end
    else
      flash[:alert] = "You must select a profile first"
    end

    respond_to do |format|
      format.html { redirect_to (parent_mode? ? videos_path : root_url) }
      format.js
    end
  end

  def index
        
    load_profiles

    set_empty_video

    if current_profile
      clear_search_key
        
      process_tag(tags_params[:name])

      load_videos

      display_results
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    load_profiles

    if session[:profile_id]
      profile = get_profile(session[:profile_id])
      
      @video = profile.videos.build(video_params)
      
      if @video.save
        flash[:notice] = "Video saved"
        
        clear_search_key
        
        load_videos
      else
        load_videos
      end
    else
      flash[:alert] = "You must select a profile to save the video under"
    end

    respond_to do |format|
      format.html { render 'videos/index' }
      format.js
    end
  end

  def update
    load_profiles

    if video_params["approved"]
      approved = (video_params["approved"] == 'true' ? true : false)
      
      if @video.update_attributes(approved: approved)
        if approved
          flash[:notice] = "Video approved"
        else
          flash[:notice]= "Video marked for review"
        end
        
        clear_search_key if num_video_by_search_key(false) == 1
        
        load_videos
      end
      
      respond_to do |format|
        format.html { render 'videos/index' }
        format.js
      end
    end
  end

  def destroy
    load_profiles

    # Remove thumbnail file
    @video.remove_thumbnail
    
    @video.destroy
    
    flash[:notice] = "Video deleted"
    
    clear_search_key if num_video_by_search_key(false) == 1
    
    load_videos
    
    respond_to do |format|
      format.html { render 'videos/index' }
      format.js
    end
  end

  private
  
    def video_params
      params.require(:video).permit(:youtube_id, :approved, :tag_list)
    end

    def tags_params
      params.require(:tags).permit(:name)
   end

    def set_empty_video
      p = Profile.new

      @video = p.videos.build
    end

    def process_tag(tag)
      tag.downcase!

      if valid_tag?(tag)
        set_search_key(tag)
      else
        set_search_key('')
        flash[:notice] = 'That is not a valid tag.'
      end
    end

    def display_results
      flash[:notice] = 'No videos match that tag.' if @videos.empty?
    end
    
    def correct_profile
      @video = current_profile.videos.find_by(id: params[:id]) if current_profile
      
      redirect_to root_url if @video.nil?
    end

    def handle_reset
      if params[:reset]
        load_videos

        respond_to do |format|
          format.html { render 'videos/index' }
          format.js { render :template => 'videos/create.js.erb' }
        end
      end
    end
end
