class SessionsController < ApplicationController
  def create
    identity = Identity.from_omniauth(request.env["omniauth.auth"])
    session[:identity_id] = identity.id
    redirect_to sandbox_path
  end

  def destroy
    session[:identity_id] = nil
    redirect_to root_path
  end
end
