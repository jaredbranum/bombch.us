require 'uri'
require  File.expand_path(File.dirname(__FILE__) + '/../lib/url_checker')

class Bombchus
  
  URL_PREFIX = 'http://bombch.us/'
  
  class InvalidURLException < Exception
    def message
      "The URL you have provided is not valid. Please try another URL."
    end
  end
  
  def self.valid_url?(url)
    u = UrlChecker.new(url)
    if u.invalid? # || u.spam? || !u.resolves?
      raise Bombchus::InvalidURLException
    end
    true
  end

  def self.used_routes
    [ 'expand', 'shorten' ]
  end
  
end
