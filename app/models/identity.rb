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

class Identity < ApplicationRecord
  validates :provider, presence: true
  validates :uid, presence: true
  validates :oauth_token, presence: true
  validates :oauth_expires_at, presence: true

  has_one :composition, -> { order 'updated_at DESC' }, inverse_of: :identity

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      oauth_token: auth.credentials.token,
      oauth_expires_at: Time.zone.at(auth.credentials.expires_at)
    )
  end
end
