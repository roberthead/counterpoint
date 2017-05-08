class NotesController < ApplicationController
  before_action :ensure_authentication!

  def create
    composition = current_identity.composition
    composition.cantus_firmus.add_note(bar: note_params[:bar], pitch: note_params[:pitch])
    redirect_to sandbox_path
  end

  def destroy
    composition.notes.where(id: params[:id]).destroy_all
    redirect_to sandbox_path
  end

  private

  def composition
    @composition ||= current_identity.composition
  end

  def note_params
    params.require(:note).permit(:bar, :pitch)
  end
end
