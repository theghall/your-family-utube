class ProfilesSessionsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  
  def create
    session[:profile_id] = Profile.find_by(name: params[:name]).id
    redirect_back fallback_location: root_path
  end
end
