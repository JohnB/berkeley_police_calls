require 'roo'

src = ARGV[0]
dst = ARGV[1] || src.gsub(/\.xls$/, '.csv')

xls = Roo::Excel.new(src)
csv = xls.to_csv
if csv =~ /^,,,\n/
  File.open(dst,'w') { |f| f.write(csv[4..-1]) }
else
  File.open(dst,'w') { |f| f.write(csv) }
end

