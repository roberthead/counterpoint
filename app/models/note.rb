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

class Note < ApplicationRecord
  belongs_to :voice
end
