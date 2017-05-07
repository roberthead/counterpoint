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

FactoryGirl.define do
  factory :voice do
    composition
    sequence(:vertical_position, 1)
    cantus_firmus false
    clef "treble"
  end
end
