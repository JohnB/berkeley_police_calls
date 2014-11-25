# Most codes are from here:
#   http://textfiles.com/hamradio/police.txt
#   http://www.ci.berkeley.ca.us/uploadedFiles/Police/Level_3_-_General/Call-Incident%20Types.pdf

ONE_DAY = 24*60*60
url = 'http://www.ci.berkeley.ca.us/uploadedFiles/Police/Level_3_-_General/%m%d%Y.xls'

earliest = Time.gm 2014,7,7 # PDF data before July 7th, 2014

date = earliest
while date < Time.now do
  filename = date.strftime(url)
  puts filename
  `wget #{filename}`
  date += ONE_DAY
end

