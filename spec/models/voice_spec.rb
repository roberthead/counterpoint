require 'rails_helper'

RSpec.describe Voice, type: :model do
  it { is_expected.to belong_to :composition }
  it { is_expected.to have_many :notes }
end
