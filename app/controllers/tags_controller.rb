class TagsController < ApplicationController
    include TagsHelper, ProfilesSessionsHelper
    
    before_action :logged_in_user
    
    # used by autocomplete, perhaps a non-RESTful action would be better
    def index

      approved = ((parent_mode? && review_mode?) ? false : true)

      # Autocomplete sends request as ?term=<tag>
      # Only used by autocomplete, so JSON is all we need right now
      # If we pulled all tags for a user then tags that exist only for an
      # unapproved video but not any approved videos would show up
      respond_to do |format|
        format.json { @tags = Tag.distinct.select(:name).joins(:videos).search(current_user.id, params[:term], approved) }
      end
        
    end
end
