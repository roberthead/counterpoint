# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_identity

  protected

  def current_identity
    @current_identity ||= Identity.find_by(id: session[:identity_id]) if session[:identity_id]
  end

  def ensure_authentication!
    redirect_to '/auth/google_oauth2' if current_identity.nil?
  end
end
