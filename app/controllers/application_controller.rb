class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include Pundit::Authorization
  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError do |ex|
    if current_user.nil?
      redirect_to new_user_session_path, alert: "You need to sign in to perform this action."
    else
      policy = ex.policy.class.to_s.underscore
      query  = ex.query.to_s
      msg = I18n.t("pundit.#{policy}.#{query}",
                   default: "You haven't permission to do this action.")
      redirect_back fallback_location: root_path, alert: msg
    end
  end
end
