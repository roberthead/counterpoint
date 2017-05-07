# == Schema Information
#
# Table name: compositions
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  key         :string           default("C major"), not null
#  meter       :string           default("4/4"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identity_id :integer          not null
#

class Composition < ApplicationRecord
  validates :name, presence: true
  validates :key, presence: true
  validates :meter, presence: true
  validates :identity, presence: true

  belongs_to :identity
  has_many :voices, inverse_of: :composition, dependent: :destroy
  has_many :counterpoint_voices, -> { where cantus_firmus: false }, class_name: 'Voice', inverse_of: :composition
  has_one :cantus_firmus, -> { where cantus_firmus: true }, class_name: 'Voice', inverse_of: :composition

  before_validation :ensure_defaults
  before_validation :ensure_voices

  DEFAULT_KEY = "C major"
  DEFAULT_METER = "4/4"

  private

  def ensure_defaults
    self.key ||= DEFAULT_KEY
    self.meter ||= DEFAULT_METER
  end

  def ensure_voices
    if self.cantus_firmus.nil?
      self.build_cantus_firmus(cantus_firmus: true, vertical_position: 2)
    end
    if counterpoint_voices.none?
      self.counterpoint_voices.build(vertical_position: 1)
    end
  end
end
