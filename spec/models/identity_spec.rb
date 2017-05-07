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

require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_presence_of(:oauth_token) }
  it { is_expected.to validate_presence_of(:oauth_expires_at) }

  it { is_expected.to have_one(:composition) }
end
