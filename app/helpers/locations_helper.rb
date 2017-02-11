module LocationsHelper
  def format_total(location, measurement)
    stat = @stats.find do |s|
      s.location_id == location.id && s.measurement_id == measurement.id
    end

    if total = stat.try(:total)
      measurement.name.include?('$') ? number_to_currency(total) : total
    else
      '-'
    end
  end
end
