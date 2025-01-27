class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    unless logged_in?
      redirect_to user_authentication_path, alert: "You must be logged in to access this section"
    end
  end

  def redirect_if_logged_in
    redirect_to dashboard_path if logged_in?
  end
end
