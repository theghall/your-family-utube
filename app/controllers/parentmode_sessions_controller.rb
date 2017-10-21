class ParentmodeSessionsController < ApplicationController
    include ApplicationHelper, ParentmodeSessionsHelper, TagsHelper

    before_action :logged_in_user, only: [:new, :create, :update]
    before_action :parent_user, only: [:update]
    
    def new
    end

    def create
        pm_params = parentmode_params

        if pm_authenticated?(pm_params)
           session[:parent_id] = current_user.id

           clear_search_key

           set_manage_mode('review')

           redirect_to videos_path(get_tags_params)
        else
          if pm_params[:password].nil?
            flash_msg = 'PIN is not valid'
          else
            flash_msg = 'Password is not valid'
          end

          flash[:alert] = flash_msg

          redirect_to new_parentmode_session_path
        end
    end

    def update
      pm_params = parentmode_params

      set_manage_mode(pm_params['mode'])

      clear_search_key

      redirect_to videos_path({tags: {name: get_search_key}})
    end

    def destroy
      exit_parent_mode

      redirect_to root_url
    end
    
    private
    
        def parentmode_params
            params.require(:parentmode).permit(:pin, :password, :mode)
        end

        def pm_authenticated?(params)
          if params[:password].nil?
            current_user.valid_pin?(params[:pin])
          else
            current_user.valid_password?(params[:password])
          end
        end
end
