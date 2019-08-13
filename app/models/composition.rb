# frozen_string_literal: true

# == Schema Information
#
# Table name: compositions
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  key_signature :string           default("C major"), not null
#  meter         :string           default("4/4"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  identity_id   :integer          not null
#

class Composition < ApplicationRecord
  validates :name, presence: true
  validates :key_signature, presence: true
  validates :meter, presence: true
  validates :identity, presence: true

  belongs_to :identity
  has_many :voices, -> { order(:vertical_position) }, inverse_of: :composition, dependent: :destroy
  has_one :cantus_firmus, -> { where cantus_firmus: true }, class_name: 'Voice', inverse_of: :composition
  has_many :counterpoint_voices, -> { counterpoint.ordered }, class_name: 'Voice', inverse_of: :composition
  has_one :counterpoint_voice, -> { counterpoint.ordered }, class_name: 'Voice', inverse_of: :composition
  has_many :notes, through: :voices

  before_validation :ensure_defaults
  before_validation :ensure_voices

  delegate :head_music_composition, to: :translation

  DEFAULT_KEY_SIGNATURE = 'C major'
  DEFAULT_METER = '4/4'

  class Translation
    include ActiveModel::Model

    attr_accessor :composition

    delegate :name, :key_signature, :meter, to: :composition

    def head_music_composition
      translate if @head_music_composition.nil?
      @head_music_composition
    end

    private

    def translate
      initialize_head_music_composition
      add_cantus_firmus_to_head_music_composition
      add_counterpoint_voices_to_head_music_composition
    end

    def initialize_head_music_composition
      @head_music_composition = HeadMusic::Composition.new(name: name, key_signature: key_signature, meter: meter)
    end

    def add_cantus_firmus_to_head_music_composition
      return unless composition.cantus_firmus

      @head_music_composition.add_voice(role: 'Cantus Firmus').tap do |head_music_cantus_firmus|
        composition.cantus_firmus.notes.each do |note|
          head_music_cantus_firmus.place("#{note.bar}:1", :whole, note.pitch)
        end
      end
    end

    def add_counterpoint_voices_to_head_music_composition
      composition.counterpoint_voices.each do |counterpoint_voice|
        add_counterpoint_voice_to_head_music_composition(counterpoint_voice)
      end
    end

    def add_counterpoint_voice_to_head_music_composition(counterpoint_voice)
      head_music_counterpoint_voice = @head_music_composition.add_voice(role: 'Counterpoint')
      counterpoint_voice.notes.each do |note|
        head_music_counterpoint_voice.place("#{note.bar}:1", :whole, note.pitch)
      end
    end
  end

  def highest_bar
    voices.map(&:highest_bar).max || 1
  end

  def first_species_counterpoint_fitness_percentage
    "#{(first_species_counterpoint_fitness * 100).round(1)}%"
  end

  def first_species_counterpoint_fitness
    (first_species_melody_analysis.fitness + first_species_harmony_analysis.fitness) / 2.0
  end

  def first_species_counterpoint_issues
    first_species_counterpoint_annotations.reject(&:adherent?).sort_by(&:start_position)
  end

  def first_species_counterpoint_annotations
    [first_species_melody_analysis.annotations, first_species_harmony_analysis.annotations].flatten.compact
  end

  def first_species_melody_analysis
    @first_species_melody_analysis ||=
      HeadMusic::Style::Analysis.new(HeadMusic::Style::Guides::FirstSpeciesMelody, head_music_counterpoint_voice)
  end

  def first_species_harmony_analysis
    @first_species_harmony_analysis ||=
      HeadMusic::Style::Analysis.new(HeadMusic::Style::Guides::FirstSpeciesHarmony, head_music_counterpoint_voice)
  end

  def head_music_counterpoint_voice
    @head_music_counterpoint_voice ||= head_music_composition.voices.detect { |voice| voice.role == 'Counterpoint' }
  end

  def cantus_firmus_fitness_percentage
    "#{(cantus_firmus_fitness * 100).round(1)}%"
  end

  def cantus_firmus_fitness
    cantus_firmus_analysis.fitness
  end

  def cantus_firmus_issues
    cantus_firmus_annotations.reject(&:adherent?).sort_by(&:start_position)
  end

  def cantus_firmus_annotations
    cantus_firmus_analysis.annotations
  end

  def cantus_firmus_analysis
    @cantus_firmus_analysis ||=
      HeadMusic::Style::Analysis.new(HeadMusic::Style::Guides::FuxCantusFirmus, head_music_cantus_firmus_voice)
  end

  def head_music_cantus_firmus_voice
    @head_music_cantus_firmus_voice ||= head_music_composition.voices.detect { |voice| voice.role == 'Cantus Firmus' }
  end

  private

  def translation
    @translation ||= Translation.new(composition: self)
  end

  def ensure_defaults
    self.key_signature ||= DEFAULT_KEY_SIGNATURE
    self.meter ||= DEFAULT_METER
  end

  def ensure_voices
    build_cantus_firmus(cantus_firmus: true, vertical_position: 1) if cantus_firmus.nil?
    counterpoint_voices.build(vertical_position: 2) if counterpoint_voices.none?
  end
end
