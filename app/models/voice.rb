class Voice < ApplicationRecord
  belongs_to :composition

  has_many :notes, inverse_of: :voice, dependent: :destroy
end
