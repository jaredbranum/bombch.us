# bombch.us

require 'sinatra'
require 'tokyocabinet'
require 'json'
require 'lib/base64url.rb'

URL_PREFIX = 'http://bombch.us/'
VALID_URL = /^[^:]+:\/\//

store ||= TokyoCabinet::HDB::new
store.open("db/url_data.tch", TokyoCabinet::HDB::OWRITER | TokyoCabinet::HDB::OCREAT)

# basic pages
get '/' do
  'home'
end

get '/404' do
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
post '/api/:url' do 
  # TODO: tokyo dystopia to prevent duplicate URLs with different keys
  full_url = params[:url]
  if full_url =~ VALID_URL
    count = store.addint(':atomic_count:', 1)
    new_key = Base64Url.encode(count)
    store.put(new_key, full_url)
    {:short_url => "#{URL_PREFIX}#{new_key}", :full_url => "#{full_url}" }.to_json
  end
end