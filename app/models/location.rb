class Location < ApplicationRecord
  validates :address, presence: true
  has_many :stats
end
