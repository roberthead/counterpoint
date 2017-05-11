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
  has_many :counterpoint_voices, -> { where(cantus_firmus: false).order(:vertical_position) }, class_name: 'Voice', inverse_of: :composition
  has_one :counterpoint_voice, -> { where(cantus_firmus: false).order(:vertical_position) }, class_name: 'Voice', inverse_of: :composition
  has_many :notes, through: :voices

  before_validation :ensure_defaults
  before_validation :ensure_voices

  DEFAULT_KEY_SIGNATURE = "C major"
  DEFAULT_METER = "4/4"

  def highest_bar
    voices.map(&:highest_bar).max || 1
  end

  def head_music_composition
    @head_music_composition ||= begin
      HeadMusic::Composition.new(name: name, key_signature: key_signature, meter: meter).tap do |hm_composition|
        hm_composition.add_voice(role: 'Cantus Firmus')
        hm_cantus_firmus = hm_composition.voices.first
        cantus_firmus.notes.each do |note|
          hm_cantus_firmus.place("#{note.bar}:1", :whole, note.pitch)
        end
        hm_composition.add_voice(role: 'Counterpoint')
        hm_counterpoint = hm_composition.voices.last
        counterpoint_voice.notes.each do |note|
          hm_counterpoint.place("#{note.bar}:1", :whole, note.pitch)
        end
      end
    end
  end

  private

  def ensure_defaults
    self.key_signature ||= DEFAULT_KEY_SIGNATURE
    self.meter ||= DEFAULT_METER
  end

  def ensure_voices
    if self.cantus_firmus.nil?
      self.build_cantus_firmus(cantus_firmus: true, vertical_position: 1)
    end
    if counterpoint_voices.none?
      self.counterpoint_voices.build(vertical_position: 2)
    end
  end
end
