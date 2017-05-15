class SandboxesController < ApplicationController
  before_action :ensure_authentication!

  class SandboxView
    include ActiveModel::Model

    attr_accessor :voice

    delegate :composition, to: :voice
    delegate :name, :voices, :cantus_firmus, :highest_bar, :key_signature, to: :composition
    delegate :id, :cantus_firmus?, to: :voice, prefix: true

    def pitches
      @pitches ||= begin
        (lowest_note.midi_note_number..highest_note.midi_note_number).map do |midi_note_number|
          HeadMusic::Pitch.get(midi_note_number)
        end
      end
    end

    private

    def highest_note
      HeadMusic::Pitch.get('C6')
    end

    def lowest_note
      HeadMusic::Pitch.get('C2')
    end
  end

  def show
    @sandbox = SandboxView.new(voice: ensure_voice)
  end

  private

  def ensure_voice
    params[:voice] =~ /cantus.?firmus/i ? ensure_composition.cantus_firmus : ensure_composition.counterpoint_voice
  end

  def ensure_composition
    current_identity.composition || Composition.create(identity: current_identity, name: t('compositions.default_name', user_name: current_identity.name))
  end
end
