require 'rubygems'
require 'sinatra'

get '/' do
  logger.info "Root Route"
  File.read(File.join('index.html'))
end
get '/google.json' do
  logger.info "Route to /google.json"
  File.read(File.join('google.json'))
end
get '/:yyyymmdd' do
  logger.info "Route to :yyyymmdd of #{params[:yyyymmdd]}."
  # File.read(File.join('index.html'))
  yyyymmdd = params[:yyyymmdd];
  if yyyymmdd =~ /\d\d\d\d\d\d\d\d.json/
    filepath = File.join(yyyymmdd)
    logger.info "Directly reading #{filepath}."
    File.read(filepath)
  else
    logger.info "Serving index for lulz."
    File.read(File.join('index.html'))
  end
  # filepath = File.join(params[:yyyymmdd] + '.json')
  # logger.info "Reading #{filepath} for REALZ!"
  # File.read(filepath)
end
# get '/:yyyymmdd.json' do
#   filepath = File.join(params[:yyyymmdd] + '.json')
#   logger.info "Reading #{filepath}"
#   File.read(filepath)
# end

