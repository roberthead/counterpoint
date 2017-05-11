# == Schema Information
#
# Table name: compositions
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  key_signature :string           default("C major"), not null
#  meter         :string           default("4/4"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  identity_id   :integer          not null
#

require 'rails_helper'

RSpec.describe Composition, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:identity) }
  it { is_expected.to have_many(:voices) }
  it { is_expected.to have_many(:counterpoint_voices) }
  it { is_expected.to have_one(:counterpoint_voice) }
  it { is_expected.to belong_to(:identity) }
  it { is_expected.to have_one(:cantus_firmus) }

  describe 'head_music_composition' do
    context 'when the composition is empty' do
      let(:composition) { FactoryGirl.create(:composition, key_signature: 'D Major') }
      subject(:head_music_composition) { composition.head_music_composition }

      it { is_expected.to be_a(HeadMusic::Composition) }

      it 'constructs and returns a head_music composition' do
        expect(subject.key_signature.spellings.map(&:to_s)).to eq %w[D E F# G A B C#]
      end
    end

    context 'when the composition has notes' do
      let(:composition) { FactoryGirl.create(:composition) }
      subject(:head_music_composition) { composition.head_music_composition }

      before do
        composition.cantus_firmus.add_note(bar: 1, pitch: 'D4')
        composition.cantus_firmus.add_note(bar: 2, pitch: 'E4')
        composition.cantus_firmus.add_note(bar: 3, pitch: 'F#4')
        composition.cantus_firmus.add_note(bar: 4, pitch: 'A4')
        composition.cantus_firmus.add_note(bar: 5, pitch: 'G4')
        composition.cantus_firmus.add_note(bar: 6, pitch: 'E4')
        composition.cantus_firmus.add_note(bar: 7, pitch: 'F#4')
        composition.cantus_firmus.add_note(bar: 8, pitch: 'E4')
        composition.cantus_firmus.add_note(bar: 9, pitch: 'D4')

        composition.counterpoint_voice.add_note(bar: 1, pitch: 'D5')
        composition.counterpoint_voice.add_note(bar: 2, pitch: 'C#5')
        composition.counterpoint_voice.add_note(bar: 3, pitch: 'A4')
        composition.counterpoint_voice.add_note(bar: 4, pitch: 'C#5')
        composition.counterpoint_voice.add_note(bar: 5, pitch: 'D5')
        composition.counterpoint_voice.add_note(bar: 6, pitch: 'G4')
        composition.counterpoint_voice.add_note(bar: 7, pitch: 'A4')
        composition.counterpoint_voice.add_note(bar: 8, pitch: 'C#5')
        composition.counterpoint_voice.add_note(bar: 9, pitch: 'D5')
      end

      its(:voices) { are_expected.to be_present }

      it 'constructs the voices' do
        cantus = subject.voices.detect { |voice| voice.role == "Cantus Firmus"}
        expect(cantus.notes.map { |note| note.pitch.to_s }).to eq %w[D4 E4 F#4 A4 G4 E4 F#4 E4 D4]
        counterpoint = subject.voices.detect { |voice| voice.role != "Cantus Firmus" }
        expect(counterpoint.notes.map { |note| note.pitch.to_s }).to eq %w[D5 C#5 A4 C#5 D5 G4 A4 C#5 D5]
      end
    end
  end

  describe 'default values' do
    let(:composition) { Composition.new }

    it 'defaults key_signature to C major' do
      expect(composition.key_signature).to eq 'C major'
    end

    it 'defaults meter to 4/4' do
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
