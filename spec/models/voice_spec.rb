# frozen_string_literal: true

# == Schema Information
#
# Table name: voices
#
#  id                :integer          not null, primary key
#  composition_id    :integer          not null
#  vertical_position :integer          default(1), not null
#  cantus_firmus     :boolean          default(FALSE), not null
#  clef              :string           default("treble"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Voice, type: :model do
  it { is_expected.to belong_to :composition }
  it { is_expected.to have_many :notes }

  describe '#highest_bar' do
    context 'with a new voice' do
      subject(:voice) { described_class.new }

      its(:highest_bar) { is_expected.to eq 1 }

      context 'with a note in the 3rd bar' do
        before do
          voice.notes << Note.new(pitch: 'D4', bar: 3)
        end

        its(:highest_bar) { is_expected.to eq 3 }
      end
    end
  end

  describe '#role' do
    subject(:role) { voice.role }

    let(:voice) { described_class.new(cantus_firmus: cantus_firmus) }

    context 'when cantus_firmus is true' do
      let(:cantus_firmus) { true }

      it { is_expected.to eq 'cantus_firmus' }
    end

    context 'when cantus_firmus is false' do
      let(:cantus_firmus) { false }

      it { is_expected.to eq 'counterpoint' }
    end
  end
end
