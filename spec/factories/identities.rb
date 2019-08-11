# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id               :integer          not null, primary key
#  provider         :string           not null
#  uid              :string           not null
#  name             :string           default("")
#  oauth_token      :string           not null
#  oauth_expires_at :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :identity do
    provider 'google_oauth2'
    sequence(:uid) { |n| "abc-#{n}" }
    name { Faker::Name.name }
    sequence(:oauth_token) { |n| "xyz-#{n}" }
    oauth_expires_at { Time.now + 1.hour }
  end
end
