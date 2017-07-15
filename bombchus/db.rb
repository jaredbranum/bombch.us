require 'mongo'
require  File.expand_path(File.dirname(__FILE__) + '/bombchus')
require  File.expand_path(File.dirname(__FILE__) + '/../lib/base64url')

class Bombchus  
  class Db
    
    def initialize(dbfile)
      @store   ||= Mongo::Connection.new.db(dbfile)
      @urls    ||= @store['urls']
      @appdata ||= @store['appdata']
      unless @appdata.find_one(:name => 'count')
        counter = { :name => 'count', :value => -1 }
        @appdata.insert(counter)
        @count_id = counter['_id']
      end
      @count_id ||= @appdata.find_one(:name => 'count')['_id']
    end
    
    def increment_count
      @appdata.update(
        { '_id' => @count_id }, 
        { '$inc' => { 'value' => 1 } }
      )
      @appdata.find_one('_id' => @count_id)['value']
    end
    
    def increment_click(key)
      begin
        @urls.update(
          { 'key' => key }, 
          { '$inc' => { 'clicks' => 1 } }
        ) if key
      rescue
        false
      end
      true
    end
    
    def expand(key)
      url_info = @urls.find_one(:key => key)
      return nil unless url_info
      url_info.delete('_id')
      url_info.merge(:url => "#{Bombchus::URL_PREFIX}#{key}")
    end
    
    def shorten(url)
      raise Bombchus::InvalidURLException unless Bombchus.valid_url?(url)
      unless doc = @urls.find_one(:long_url => url)
        begin
          count = increment_count
          key = Base64Url.encode(count)
        end while Bombchus.used_routes.include? key
        doc = {
          'key' => key,
          'long_url' => url,
          'clicks' => 0
        }
        @urls.insert(doc)
      end
      doc.delete('_id')
      doc.merge('url' => "#{Bombchus::URL_PREFIX}#{doc['key']}")
    end

    def delete!(key)
      @urls.remove(:key => key)
    end

  end
end