require 'uri'

class Bombchus
  
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
  
end