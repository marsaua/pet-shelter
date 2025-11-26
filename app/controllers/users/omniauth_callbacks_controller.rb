class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = SsoIdentity.upsert_from_omniauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      return
    end
    nil
  end

  def github
    @user = SsoIdentity.upsert_from_omniauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?
      return
    end
    redirect_to new_user_session_path, alert: "Authentication failed. Please try again."
  end

  def failure
    redirect_to root_path, alert: "Authentication failed. Please try again."
  end

  private

  def handle_auth(provider)
    auth = request.env["omniauth.auth"]
    unless auth
      redirect_to root_path, alert: "No auth data received"
      return
    end

    user = User.from_omniauth(auth)

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      return set_flash_message(:notice, :success, kind: provider.titleize) if is_navigational_format?
    end

    redirect_to new_user_registration_url, alert: "Authentication failed. Please try again."
  end
end
