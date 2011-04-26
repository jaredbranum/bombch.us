# bombch.us

require 'sinatra'
require 'json'
require File.expand_path(File.dirname(__FILE__) + '/bombchus/db')

db = Bombchus::Db.new("bombchus")

# basic pages
get '/' do
  erb :index
end

not_found do
  erb :'404'
end

# API routes
post '/shorten/new/?' do
  begin
    content_type :json
    (db.shorten(params['url']) || {}).to_json
  rescue Bombchus::InvalidURLException => e
    status 500
    body e.message
  end
end

get '/expand/:key' do
  content_type :json
  (db.expand(params[:key]) || {}).to_json
end

# redirect route
get '/:urlkey' do
  urldata = db.expand(params[:urlkey])
  url = urldata['long_url'] if urldata
  if url && Bombchus::valid_url?(url)
    db.increment_click(urldata['key'])
    redirect url
  else
    status 404
  end
end