require 'yaml'
require 'geocoder'
require File.join(__dir__,'police_codes')

# Read in the locations
slim_locations = YAML.load_file 'slim_locations.yml'

src = ARGV[0]
# Expect mmddyyyy.csv src format. Swap it to yyyymmdd.geojson dst format
dst = "#{src[4..7]}#{src[0..3]}#{src[8..-1].gsub(/\.csv/,'')}.geojson"
puts "Attempting to convert #{src} to #{dst}."


altitude = 0
features = []
code_translator = PoliceCodes.new("(???)")
CSV.foreach(src) do |row|
  date_time, call_incident_type, incident_no, full_address = row
  geocode = slim_locations[full_address]
  if geocode
    coordinates = [geocode['longitude'], geocode['latitude'], altitude]
    title = "%s: %s (%s) near %s" % [date_time, call_incident_type, incident_no, full_address]
    date, time = date_time.split(/\s+/)
    type_translation = code_translator.translate(call_incident_type).strip
    features << {
        "type" => "Feature",
        "geometry" => {
            "type" => "Point",
            "coordinates" => coordinates
        },
        "properties" => {
            "time" => time.to_s,
            "date" => date.to_s,
            "Approx. Location" => full_address,
            "Incident Type" => "<a href='http://www.ci.berkeley.ca.us/uploadedFiles/Police/Level_3_-_General/Call-Incident%20Types.pdf'>#{call_incident_type}</a> (#{type_translation})",
            "Incident Number" => incident_no
        }
    }
  end
end
output = { "type" => "FeatureCollection", "features" => features }

# emit a JSON hash of our points
File.open(dst,'w') { |f| f.puts(output.to_json) }
