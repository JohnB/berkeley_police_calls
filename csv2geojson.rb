require 'yaml'
require 'geocoder'

# Read in the locations
slim_locations = YAML.load_file 'slim_locations.yml'

# Read in the CSV file specified in ARGV[0]
src = ARGV[0]
dst = "#{src.gsub(/\.csv/,'')}.json"
puts "Attempting to convert #{src} to #{dst}."

altitude = 0
features = []
CSV.foreach(src) do |row|
  date_time, call_incident_type, incident_no, full_address = row
  geocode = slim_locations[full_address]
  if geocode
    coordinates = [geocode['latitude'], geocode['longitude'], altitude]
    title = "%s: %s (%s) near %s" % [date_time, call_incident_type, incident_no, full_address]
    features << {
        "type" => "Feature",
        "geometry" => {
            "type" => "Point",
            "coordinates" => coordinates
        },
        "properties" => {
            "visible" => true,
            "title" => title
        }
    }
  end
end
output = { "type" => "FeatureCollection", "features" => features }

# emit a JSON hash of our points
File.open(dst,'w') { |f| f.puts(output.to_json) }
