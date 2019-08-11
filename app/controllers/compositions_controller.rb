# frozen_string_literal: true

class CompositionsController < ApplicationController
  before_action :ensure_authentication!

  def update
    composition.update_attributes(composition_params)
    redirect_back(fallback_location: root_path)
  end

  private

  def composition
    @composition ||= Composition.where(identity_id: current_identity.id).find(params[:id])
  end

  def composition_params
    params.require(:composition).permit(:key_signature)
  end
end
