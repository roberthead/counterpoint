require 'rails_helper'

RSpec.describe Composition, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:key_signature) }
  it { is_expected.to validate_presence_of(:meter) }
end
