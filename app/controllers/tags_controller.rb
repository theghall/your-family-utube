class TagsController < ApplicationController
    include TagsHelper, ProfilesSessionsHelper
    
    before_action :logged_in_user
    
    def index
        
        clear_search_key
        
        set_search_key(tags_params[:name])
        
        load_videos
        
        if @videos.empty?
            flash[:notice] = 'No videos matching that search term were found' 
        end
       
        @videos.empty? ? set_curr_vid_url(nil) : set_curr_vid_url(get_video_url(@videos.first))
    
        respond_to do |format|
            format.html { redirect_to parent_path }
            format.js
        end
    end
    
    private
    
        def tags_params
            params.require(:tags).permit(:name)
        end
end
