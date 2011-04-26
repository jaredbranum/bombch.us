require 'tokyocabinet'
require  File.expand_path(File.dirname(__FILE__) + '/bombchus')
require  File.expand_path(File.dirname(__FILE__) + '/../lib/base64url')

class Bombchus  
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
      raise Bombchus::InvalidURLException unless Bombchus.valid_url?(url)
      
      count = @store.addint(':url_count:', 1)
      key = Base64Url.encode(count)
      @store.put(key, url)
      key
    end
    
  end
end