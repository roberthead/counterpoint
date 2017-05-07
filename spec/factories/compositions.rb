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

FactoryGirl.define do
  factory :composition do
    name { Faker::LordOfTheRings.location }
    identity
  end
end
