# == Schema Information
#
# Table name: voices
#
#  id                :integer          not null, primary key
#  composition_id    :integer          not null
#  vertical_position :integer          default(1), not null
#  cantus_firmus     :boolean          default(FALSE), not null
#  clef              :string           default("treble"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Voice < ApplicationRecord
  belongs_to :composition

  has_many :notes, inverse_of: :voice, dependent: :destroy
end
