# == Schema Information
#
# Table name: compositions
#
#  id         :integer          not null, primary key
#  name       :string
#  key        :string
#  meter      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :composition do
    name { Faker::LordOfTheRings.location }
  end
end
