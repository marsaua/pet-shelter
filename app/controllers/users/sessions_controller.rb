# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: %i[create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def google
    auth = request.env["omniauth.auth"]

    user = SsoIdentity.upsert_from_omniauth(auth)

    redirect_to new_user_session_path, alert: "Google sign-in failed. Please try again." unless user

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?

  rescue => e
    Rails.logger.error "[Omniauth][Google] #{e.class}: #{e.message}"
    redirect_to new_user_session_path, alert: "Google sign-in failed."
  end

  def failure
    redirect_to new_user_session_path, alert: "Authentication failed."
  end
end
