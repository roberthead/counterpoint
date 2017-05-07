class EditorsController < ApplicationController
  before_action :ensure_composition

  def show
  end

  private

  def ensure_composition
    @composition ||= Composition.find(params[:composition_id])
  end
end
