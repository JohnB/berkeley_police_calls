# Codes extracted from http://www.ci.berkeley.ca.us/uploadedFiles/Police/Level_3_-_General/Call-Incident%20Types.pdf
# are in the police_codes.txt file. This code parses them into a big hash.

class PoliceCodes
  SRC_FILENAME = 'police_codes.txt'
  SRC_FILEPATH = File.join(__dir__, SRC_FILENAME)

  def initialize(default_response = nil)
    @default_response = default_response || "[UNKNOWN]"
  end

  def translate(code)
    codes[code]
  end

  def list
    codes.keys.sort.each do |key|
      puts "%-10.10s%s" % [key, codes[key]]
    end
  end

  private

  def codes
    @codes ||= begin
      data = IO.read(SRC_FILEPATH).split("\n")
      hash = Hash.new(@default_response)
      data.each do |line|
        if line =~ /^([^-]+)-(.*)\s*$/
          hash[$1] = $2
        else
          puts "Bad line: '#{line}'."
        end
      end
      hash
    end
  end
end

# PoliceCodes.new.list
