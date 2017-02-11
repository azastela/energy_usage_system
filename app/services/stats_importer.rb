class StatsImporter
  def import
    rows.each do |row|
      Row.new(self, row)
    end
  end

  def import
    ActiveRecord::Base.transaction do
      rows.each{ |row| Row.new(self, row).save }
    end
  end

  protected

  def rows
    @rows ||= soda_client.get(
      Rails.application.secrets.socrata['resource'],
      :$limit => 5000
    ).reject(&:blank?)
  end

  def soda_client
    @soda_client ||= SODA::Client.new({
      domain: Rails.application.secrets.socrata['domain'],
      app_token: Rails.application.secrets.socrata['api_key']
    })
  end

  def log(msg)
    logger.info msg
  end

  def logger
    @logger ||= Logger.new('import.log')
  end

  class Row
    MEASUREMENT_FIELD = 'measurement'
    LOCATION_FIELD = 'location_1_location'

    delegate :log, to: :importer
    attr_reader :row, :importer

    def initialize(importer, row)
      @row, @importer = row, importer
    end

    def save
      stats.each(&:save!)
    rescue => e
      log "Exception occured while processing #{row.inspect}: #{e}"
    end

    private

    def stats
      Stat::YEARS.map do |year|
        stat = Stat.find_by(location: location, measurement: measurement, year: year)
        stat.total = parse_total(year) if stat
        stat || Stat.new(stat_params(year))
      end
    end

    def stat_params(year)
      { location: location,
        measurement: measurement,
        year: year,
        total: parse_total(year) }
    end

    def location
      Location.find_or_create_by(address: row[LOCATION_FIELD].try(:strip))
    end

    def measurement
      Measurement.find_or_create_by(name: row[MEASUREMENT_FIELD].try(:strip))
    end

    def parse_total(year)
      row.reject{ |k, v| !k.end_with?(year.to_s[-2..-1]) }.values.inject(0){ |s, v| s + v.to_f }
    end
  end
end