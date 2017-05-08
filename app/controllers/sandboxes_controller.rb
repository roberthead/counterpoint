class SandboxesController < ApplicationController
  before_action :ensure_authentication!

  class MarkView
    include ActiveModel::Model

    attr_accessor :mark

    delegate :start_position, to: :mark

    def start_bar
      start_position.to_s.split(/:/).first.to_i
    end
  end

  class AnnotationView
    include ActiveModel::Model

    attr_accessor :annotation

    delegate :fitness, :message, to: :annotation

    def earliest_bar
      marks.first.start_bar
    end

    def marks
      [annotation.marks].flatten.map { |mark| MarkView.new(mark: mark) }.sort_by(&:start_bar)
    end
  end

  class SandboxView
    include ActiveModel::Model

    attr_accessor :composition

    delegate :name, :voices, :cantus_firmus, :highest_bar, to: :composition

    def annotations
      @annotations ||= analysis.annotations.select { |annotation|
        annotation.fitness < 1.0
      }.map { |annotation|
        AnnotationView.new(annotation: annotation)
      }.sort_by(&:earliest_bar)
    end

    def analysis
      @analysis ||= begin
        hm_composition = HeadMusic::Composition.new(name: composition.name, key_signature: composition.key)
        hm_voice = HeadMusic::Voice.new(role: "Cantus Firmus", composition: hm_composition)
        cantus_firmus.notes.each do |note|
          hm_voice.place("#{note.bar}:1:0", :whole, note.pitch.to_s)
        end
        HeadMusic::Style::Analysis.new(HeadMusic::Style::Rulesets::CantusFirmus, hm_voice)
      end
    end
  end

  def show
    @sandbox ||= SandboxView.new(composition: ensure_composition)
  end

  private

  def ensure_composition
    @composition ||= current_identity.composition || Composition.create(identity: current_identity, name: t('compositions.default_name', user_name: current_identity.name))
  end
end
