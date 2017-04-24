# == Schema Information
#
# Table name: voices
#
#  id                :integer          not null, primary key
#  composition_id    :integer
#  vertical_position :integer
#  cantus_firmus     :boolean
#  clef              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Voice < ApplicationRecord
  belongs_to :composition

  has_many :notes, inverse_of: :voice, dependent: :destroy
end
