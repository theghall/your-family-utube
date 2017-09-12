class TagsController < ApplicationController
    include TagsHelper, ProfilesSessionsHelper
    
    before_action :logged_in_user
    
    def index
        
        clear_search_key
        
	# An empty search key does nothing
	if valid_tag?(tags_params[:name])
           set_search_key(tags_params[:name])
        
           load_videos

           if @videos.empty?
              flash[:notice] = 'No videos matching that search term were found' 
           end
        else
           flash[:notice] = "That is not a valid tag."
        end

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
