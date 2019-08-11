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

FactoryGirl.define do
  factory :composition do
    name { Faker::Movies::LordOfTheRings.location }
    identity
  end
end
