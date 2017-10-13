class SettingsController < ApplicationController
  include ApplicationHelper, SettingsHelper

  before_action :logged_in_user, only: [:index, :update]
  before_action :parent_user, only: [:index, :update]

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
      
      any_changed = false

      all_succeeded = true

      if setting.value != s['value']
        setting.update_attribute(:value, s['value'])

        all_succeeded &= setting.save

        any_changed = true
      end

      if all_succeeded
        flash[:notice] = 'All updated suceeded'
      else
        flash[:alert] = 'Some or all updates failed.' if any_changed
      end

      flash[:notice] = 'Nothing to save' if !any_changed && all_succeeded
    end

    redirect_to settings_path
  end

  private
    def settings_params
      params.require(:settings).permit(:profiles => [ :profile_id, :setting_id, :value ])
    end
end
