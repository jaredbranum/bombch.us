require 'tokyocabinet'
require  File.expand_path(File.dirname(__FILE__) + '/../lib/base64url')

class Bombchus
  VALID_URL = /\w:\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
  class InvalidURLException < Exception
    def message
      "The URL you have provided is not valid. Please try another URL."
    end
  end
  
  class Db
    
    def initialize(dbfile)
      @store ||= TokyoCabinet::HDB::new
      @store.open(dbfile, TokyoCabinet::HDB::OWRITER | TokyoCabinet::HDB::OCREAT)
    end
    
    def expand(key)
      @store.get(key)
    end
    
    def shorten(url)
      # TODO: check to see if there is already an entry
      # (use tokyo dystopia?)
      raise Bombchus::InvalidURLException unless url =~ Bombchus::VALID_URL
      
      count = @store.addint(':url_count:', 1)
      key = Base64Url.encode(count)
      @store.put(key, url)
      key
    end
    
  end
end