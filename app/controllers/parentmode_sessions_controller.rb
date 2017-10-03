class ParentmodeSessionsController < ApplicationController
    include ParentmodeSessionsHelper, TagsHelper

    before_action :logged_in_user, only: [:new, :create]
    
    def new
    end

    def create
        params = parentmode_params

        if pm_authenticated?(params)
           session[:parent_id] = current_user.id

           clear_search_key

           redirect_to parent_path
        else
          if params[:password].nil?
            flash_msg = 'PIN is not valid'
          else
            flash_msg = 'Password is not valid'
          end

          flash[:alert] = flash_msg

          redirect_to new_parentmode_session_path
        end
    end

    def destroy
      exit_parent_mode

      redirect_to root_url
    end
    
    private
    
        def parentmode_params
            params.require(:parentmode).permit(:pin, :password)
        end

        def pm_authenticated?(params)
          if params[:password].nil?
            current_user.valid_pin?(params[:pin])
          else
            current_user.valid_password?(params[:password])
          end
        end
end
