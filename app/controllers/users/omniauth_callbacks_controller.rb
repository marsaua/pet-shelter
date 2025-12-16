class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = SsoIdentity.upsert_from_omniauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      redirect_to new_user_session_path, alert: "Authentication failed. Please try again."
    end
  end

  def github
    @user = SsoIdentity.upsert_from_omniauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?
    else
      redirect_to new_user_session_path, alert: "Authentication failed. Please try again."
    end
  end

  def failure
    redirect_to root_path, alert: "Authentication failed. Please try again."
  end
end
