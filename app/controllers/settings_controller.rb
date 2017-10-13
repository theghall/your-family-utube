class SettingsController < ApplicationController
  include SettingsHelper

  before_action :logged_in_user, only: [:index, :update]

  def index
    @profile_settings = User.find(current_user.id).profile_settings
  end

  def update
    # Since can't serialize data on a HTML doc yet, javascript intercepts
    # the submit, serializes the form data, and makes an ajax call to this
    # named route.
    #
    settings = settings_params

    settings['profiles'].each do |s|
      setting = ProfileSetting.find_by(profile_id: s['profile_id'].to_i, \
                                       setting_id: s['setting_id'].to_i)
      
      if setting.value != s['value']
        setting.update_attribute(:value, s['value'])

        setting.save
      end
    end

    redirect_to settings_path
  end

  private
    def settings_params
      params.require(:settings).permit(:profiles => [ :profile_id, :setting_id, :value ])
    end
end
