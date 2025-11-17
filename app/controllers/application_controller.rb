class ApplicationController < ActionController::Base
  include Pundit::Authorization
  allow_browser versions: :modern

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_back fallback_location: root_path, alert: I18n.t("pundit.unauthorized")
  end
end
