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

require 'rails_helper'

RSpec.describe Composition, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:voices) }

  describe 'default values' do
    let(:composition) { Composition.new }

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

  describe 'validation lifecycle' do
    let(:composition) { Composition.new }

    it 'ensures a cantus firmus' do
      expect {
        composition.valid?
      }.to change {
        composition.cantus_firmus.present?
      }.to true
    end
  end
end
