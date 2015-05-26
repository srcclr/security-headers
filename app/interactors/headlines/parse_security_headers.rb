module Headlines
  class ParseSecurityHeaders
    include Interactor

    SECURITY_HEADERS = %w(strict-transport-security
                          x-xss-protection
                          x-content-type-options
                          x-frame-options
                          content-security-policy)

    def call
      context.headers = parse_headers(connection.get("/").headers)
    end

    private

    def parse_headers(headers)
      headers.slice(*SECURITY_HEADERS).map do |header|
        header_class(header).new(header).params
      end
    end

    def header_class(header)
      "Headlines::SecurityHeaders::#{header[0].titleize.gsub(' ', '')}".constantize
    end

    def connection
      Faraday.new(url: "http://#{context.url}") do |builder|
        builder.request :url_encoded
        builder.response :logger
        builder.use FaradayMiddleware::FollowRedirects, limit: 10
        builder.adapter Faraday.default_adapter
      end
    end
  end
end
