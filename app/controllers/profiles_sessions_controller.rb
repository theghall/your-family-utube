class ProfilesSessionsController < ApplicationController
  def create
    session[:profile_id] = Profile.find_by(name: params[:name]).id
    redirect_to root_url
  end
end
