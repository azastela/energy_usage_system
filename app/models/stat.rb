class Stat < ApplicationRecord
  YEARS = [2008, 2009, 2010, 2011, 2012]

  belongs_to :location
  belongs_to :measurement

  # validates_uniqueness_of :location_id, scope: :measurement_id
  validates_presence_of :location, :measurement, :year, :total
end
