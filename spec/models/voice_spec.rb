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
end
