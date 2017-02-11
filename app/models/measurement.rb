class Measurement < ApplicationRecord
  validates :name, presence: true
  has_many :stats
end
