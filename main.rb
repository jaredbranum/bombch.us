# bombch.us

require 'sinatra'
require 'json'
require File.expand_path(File.dirname(__FILE__) + '/bombchus/db')

URL_PREFIX = 'http://bombch.us/'
db = Bombchus::Db.new(File.expand_path(File.dirname(__FILE__) + "/db/url_data.tch"))

# basic pages
get '/' do
  erb :index
end

not_found do
  erb :'404'
end

# API routes
post '/shorten/new/?' do
  url = params['url']
  begin
    key = db.shorten(url)
    content_type :json
    {:url => "#{URL_PREFIX}#{key}", :original_url => "#{url}" }.to_json
  rescue Bombchus::InvalidURLException => e
    status 500
    body e.message
  end
end

get '/expand/:key' do
  key = params[:key]
  url = db.expand(key)
  content_type :json
  {:url => "#{URL_PREFIX}#{key}", :original_url => "#{url}" }.to_json
end

# redirect route
get '/:urlkey' do
  url = db.expand(params[:urlkey])
  if url.nil? || !(url =~ Bombchus::VALID_URL)
    status 404
  else
    redirect url
  end
end