# == Schema Information
#
# Table name: compositions
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  key         :string           default("C major"), not null
#  meter       :string           default("4/4"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identity_id :integer          not null
#

require 'rails_helper'

RSpec.describe Composition, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:identity) }
  it { is_expected.to have_many(:voices) }
  it { is_expected.to have_many(:counterpoint_voices) }
  it { is_expected.to belong_to(:identity) }
  it { is_expected.to have_one(:cantus_firmus) }

  describe 'default values' do
    let(:composition) { Composition.new }

    it 'defaults key to C major' do
      expect(composition.key).to eq 'C major'
    end

    it 'defaults key to 4/4' do
      expect(composition.meter).to eq '4/4'
    end
  end

  describe 'validation lifecycle' do
    let(:composition) { FactoryGirl.build(:composition) }

    context 'when the composition has no voices' do
      it 'builds a cantus firmus' do
        expect {
          composition.valid?
        }.to change {
          composition.cantus_firmus.present?
        }.from(false).to(true)
      end

      it 'builds a counterpoint voice' do
        expect {
          composition.valid?
        }.to change {
          composition.counterpoint_voices.size
        }.from(0).to(1)
      end

      it 'ensures a cantus firmus' do
        expect {
          composition.save!
        }.to change {
          Voice.where(cantus_firmus: true).count
        }.by 1
      end

      it 'ensures a counterpoint line' do
        expect {
          composition.save!
        }.to change {
          Voice.where(cantus_firmus: false).count
        }.by 1
      end
    end

    context 'when the composition has two voices' do
      let!(:composition) { FactoryGirl.create(:composition) }

      it 'is content with the existing cantus firmus' do
        expect {
          composition.save!
        }.not_to change {
          Voice.where(cantus_firmus: true).count
        }
      end

      it 'is content with the existing counterpoint voice' do
        expect {
          composition.save!
        }.not_to change {
          Voice.where(cantus_firmus: false).count
        }
      end
    end
  end
end
