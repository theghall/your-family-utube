class RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  before_action :parent_user, only: [:edit]

  def create
    super
  end

  def edit
    super
  end

private

    def sign_up_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :pin, :pin_confirmation)
    end

    def account_update_params
     params.require(:user).permit(:name, :email, :pin, :pin_confirmation, :password, :password_confirmation, :current_password)
    end
end
