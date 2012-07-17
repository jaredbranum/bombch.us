require 'uri'

class Bombchus
  
  URL_PREFIX = 'http://bombch.us/'
  
  class InvalidURLException < Exception
    def message
      "The URL you have provided is not valid. Please try another URL."
    end
  end
  
  def self.valid_url?(url)
    begin
      u = URI.parse(url)
      if u.host.nil? || u.host.empty? || 
         u.port.nil? || !u.port.is_a?(Integer) || 
         u.path.nil?
        raise Bombchus::InvalidURLException
      end 
    rescue URI::InvalidURIError => e
      raise Bombchus::InvalidURLException
    end
    true
  end

  def self.used_routes
    [ 'expand', 'shorten' ]
  end
  
end