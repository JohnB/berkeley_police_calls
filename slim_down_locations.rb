require 'yaml'
require 'geocoder'

# Read in the locations
hh = YAML.load_file 'locations9c.yml'

# Generate a hash of location name to lat/lon
output = {}
hh.each do |key, value|
  if value
    output[key] = {"latitude" => value.latitude, "longitude" => value.longitude, }
  else
    puts "nil value for #{key}"
  end
end

# Emit as slim_locations.yml
File.open('slim_locations.yml', 'w') {|f| YAML.dump(output, f) }
