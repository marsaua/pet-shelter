# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

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

    user = User.find_or_initialize_by(google_uid: auth.uid)
    user.email = auth.info.email
    creds = auth.credentials

    user.google_access_token      = creds.token
    user.google_refresh_token   ||= creds.refresh_token
    user.google_token_expires_at  = Time.at(creds.expires_at) if creds.expires_at
    user.save!

    session[:user_id] = user.id
    redirect_to root_path, notice: "Signed in with Google"
  end
end
