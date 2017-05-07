class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_identity

  protected

  def current_identity
    @current_identity ||= Identity.find_by(id: session[:identity_id]) if session[:identity_id]
  end
end
