class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    email = request.headers["X-AUTH-EMAIL"]
    auth_token = request.headers["X-AUTH-TOKEN"]
    return nil if email.blank? || auth_token.blank?
    User.where(email: email,auth_token: auth_token).take
  end

  protected

  def authenticate_user!
    unless current_user
      head :unauthorized
    end
  end
end
