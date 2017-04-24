# == Schema Information
#
# Table name: voices
#
#  id                :integer          not null, primary key
#  composition_id    :integer
#  vertical_position :integer
#  cantus_firmus     :boolean
#  clef              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Voice, type: :model do
  it { is_expected.to belong_to :composition }
  it { is_expected.to have_many :notes }
end
