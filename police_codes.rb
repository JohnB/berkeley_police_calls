# Codes extracted from http://www.ci.berkeley.ca.us/uploadedFiles/Police/Level_3_-_General/Call-Incident%20Types.pdf
# are in the police_codes.txt file. This code parses them into a big hash.

class PoliceCodes
  def codes
    @codes ||= begin
      data = IO.read('police_codes.txt').split("\n")
      hash = {}
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

  def list
    codes.keys.sort.each do |key|
      puts "%-10.10s%s" % [key, codes[key]]
    end
  end
end

PoliceCodes.new.list

