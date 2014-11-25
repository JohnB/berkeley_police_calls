require 'yaml'
require 'geocoder'


class GeocodeLocations
  def initialize(filename)
    @filename = filename
  end

  def geocode
    locations = YAML.load_file('locations.yml') || {}
    puts "Number of locations at start: #{locations.length}"
    past_first_line = false
    existing, newer = 0,0
    CSV.foreach(@filename) do |row|
      unless past_first_line
        past_first_line = true
        next
      end
      loc = row[3]
      if locations[loc]
        existing += 1
        # puts "Known: #{loc}"
      else
        newer += 1
        g = Geocoder.search(loc + ", berkeley, CA")
        puts "New: #{loc} "
        locations[loc] = g.first
        # if we want to back up the 4MB yaml file, pause at this point
        puts 3
        sleep 1
        puts 2
        sleep 1
        puts 1
        sleep 1
        File.open('locations.yml', 'w') {|f| YAML.dump(locations, f) }
        puts 0
      end
    end
    puts "Existing: %d, new: %d, total: %d\n" % [existing, newer, locations.length]
  end
end

csv_file =  ARGV[0]
if csv_file
  GeocodeLocations.new( csv_file ).geocode
else
  puts "USAGE: #{__FILE__} csv_file\n  Extracts locations from the CSV file, geocodes them, and writes them all to locations.yml"
end


