class StaticPagesController < ApplicationController
  def home
    if !current_user.nil?
      @profiles = current_user.profiles.all
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
