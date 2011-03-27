# bombch.us

require 'sinatra'
require 'tokyocabinet'
require 'json'
require 'lib/base64url.rb'

URL_PREFIX = 'http://localhost:4567/' #'http://bombch.us/'
VALID_URL = /^[^:]+:\/\//

store ||= TokyoCabinet::HDB::new
store.open("db/url_data.tch", TokyoCabinet::HDB::OWRITER | TokyoCabinet::HDB::OCREAT)

# basic pages
get '/' do
  erb :index
end

get '/404/?' do
  'page not found'
end

# redirect route
get '/:urlkey' do
  key = params[:urlkey]
  full_url = store.get(key)
  redirect '/404' if full_url.nil?
  redirect full_url if full_url =~ VALID_URL
  redirect '/404'
end

# API
post '/api/shorten/new/?' do
  # TODO: tokyo dystopia to prevent duplicate URLs with different keys
  
  long_url = params['long_url']
  if long_url =~ VALID_URL
    count = store.addint(':atomic_count:', 1)
    new_key = Base64Url.encode(count)
    store.put(new_key, long_url)
    
    content_type :json
    {:short_url => "#{URL_PREFIX}#{new_key}", :long_url => "#{long_url}" }.to_json
  else
    'Error: Invalid long_url value.'
  end
end