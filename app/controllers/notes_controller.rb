# frozen_string_literal: true

class NotesController < ApplicationController
  before_action :ensure_authentication!

  def create
    composition = current_identity.composition
    voice = composition.voices.find(note_params[:voice_id])
    voice.add_note(bar: note_params[:bar], pitch: note_params[:pitch])
    redirect_to sandbox_path(voice: voice.role)
  end

  def destroy
    note = Note.where(id: params[:id]).first
    note.destroy
    redirect_to sandbox_path(voice: note.try(:voice).try(:role))
  end

  private

  def composition
    @composition ||= current_identity.composition
  end

  def note_params
    params.require(:note).permit(:bar, :pitch, :voice_id)
  end
end
