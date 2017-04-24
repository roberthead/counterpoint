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

FactoryGirl.define do
  factory :voice do
    composition
    vertical_position 1
    cantus_firmus false
    clef "treble"
  end
end
