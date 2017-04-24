require 'rails_helper'

RSpec.describe Composition, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:voices) }

  describe 'default values' do
    let(:composition) { Composition.new(name: 'Fruit Salad') }

    it 'defaults key to C major' do
      expect {
        composition.valid?
      }.to change {
        composition.key
      }.from(nil).to('C major')
    end

    it 'defaults key to 4/4' do
      expect {
        composition.valid?
      }.to change {
        composition.meter
      }.from(nil).to('4/4')
    end
  end
end
