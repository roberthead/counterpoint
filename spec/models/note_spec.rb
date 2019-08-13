# frozen_string_literal: true

# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  voice_id   :integer          not null
#  bar        :integer          default(1), not null
#  pitch      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Note, type: :model do
  it { is_expected.to belong_to :voice }

  describe 'normalization' do
    let(:note) { described_class.new(bar: '5', pitch: '78') }

    it 'converts midi note numbers to spelling' do
      expect { note.valid? }.to change(note, :pitch).from('78').to('F♯5')
    end
  end
end
