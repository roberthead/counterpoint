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

class Composition < ApplicationRecord
  validates :name, presence: true
  validates :key, presence: true
  validates :meter, presence: true

  has_many :voices, inverse_of: :composition, dependent: :destroy

  before_validation :ensure_defaults

  private

  def ensure_defaults
    self.key ||= "C major"
    self.meter ||= "4/4"
  end
end
