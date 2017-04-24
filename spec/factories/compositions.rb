FactoryGirl.define do
  factory :composition do
    name { Faker::Hobbit.location }
    vertical_position 1
    cantus_firmus false
    clef "treble"
  end
end
