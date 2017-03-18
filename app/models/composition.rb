class Composition < ApplicationRecord
  validates :name, presence: true
  validates :key_signature, presence: true
  validates :meter, presence: true
end
