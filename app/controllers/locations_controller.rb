class LocationsController < ApplicationController
  def index
    @year = params[:year] || Stat::YEARS.first
    @locations = Location.order(:address).all
    @measurements = Measurement.all
    @stats = Stat.where(year: @year)
  end
end
