require 'uri'
require 'net/http'
require 'charon'
require 'surbl_client'

class UrlChecker

  def initialize(url)
    @url = url
    @uri = URI(@url)
  end

  def invalid?
    [
      @uri.host.nil?,
      @uri.host.empty?,
      @uri.port.nil?,
      !@uri.port.is_a?(Integer),
      @uri.path.nil?
    ].any?
  rescue URI::InvalidURIError => e
    true
  end

  def spam?
    [
      Charon.query(@uri.host), # SpamHaus
      SurblClient.new.include?(@uri.host) # SURBL
    ].any?
  end

  def resolves?
    Net::HTTP.get_response(@uri).code.to_i < 300
  rescue
    false
  end
  
end
