require 'faraday'
require 'faraday_middleware'

module Headlines
  class SiteHeadersParser
    SECURITY_HEADERS = %w(strict-transport-security
                          x-xss-protection
                          x-content-type-options
                          x-frame-options
                          content-security-policy)

    def initialize(url)
      @url = "http://#{url}"
    end

    def self.analyze(url)
      new(url).analyze
    end

    def analyze
      parseHeaders(connection.get('/').headers)
    end

    private

    def parseHeaders(headers)
      headers.slice(*SECURITY_HEADERS).each do |header|
        object = header_class(header).new(header).parse
      end
    end

    def header_class(header)
      "Headlines::#{header[0].titleize.gsub(' ', '')}".constantize
    end

    def connection
      Faraday.new(url: @url) do |builder|
        builder.request :url_encoded
        builder.response :logger
        builder.use FaradayMiddleware::FollowRedirects, limit: 10
        builder.adapter Faraday.default_adapter
      end
    end
  end
end
