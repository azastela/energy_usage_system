namespace :import do
  desc 'Import data from socrata api. Usage rake import:data'
  task data: :environment do
    puts 'Importing...'
    StatsImporter.new.import
    puts 'Done'
  end
end