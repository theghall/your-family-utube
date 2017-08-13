class ParentmodeSessionsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create]
    
    def new
    end

    def create
        if current_user.parent_authenticated?(parentmode_params[:pin]) 
           session[:parent_id] = current_user.id
           redirect_to videos_path
        else
            flash[:alert] = "PIN is not valid"
            redirect_to new_parentmode_session_path
        end
    end
    
    private
    
        def parentmode_params
            params.require(:parentmode).permit(:pin)
        end
end
