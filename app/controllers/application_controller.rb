class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
    private
  
    def logged_in_user
      unless user_signed_in?
        flash[:alert] = "Please Signin"
        redirect_to new_user_session_url
      end
    end
end
