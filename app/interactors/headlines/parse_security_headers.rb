module Headlines
  class ParseSecurityHeaders
    include Interactor

    SECURITY_HEADERS = %w(strict-transport-security
                          x-xss-protection
                          x-content-type-options
                          x-frame-options
                          content-security-policy)

    def call
      context.fail! unless response.success?

      context.headers = parse_headers(response.headers)
    rescue Faraday::ClientError
      context.fail!(message: I18n.t("connection.failed", url: context.url))
    end

    private

    def response
      @response ||= connection.get("/")
    end

    def parse_headers(headers)
      headers.slice(*SECURITY_HEADERS).map do |(header, value)|
        header_class(header).new(header, value)
      end
    end

    def header_class(header)
      "Headlines::SecurityHeaders::#{header.titleize.gsub(' ', '')}".constantize
    end

    def connection
      Faraday.new(url: "http://#{context.url}", headers: { accept_encoding: "none" }) do |builder|
        builder.request :url_encoded
        builder.response :logger
        builder.use FaradayMiddleware::FollowRedirects, limit: 10
        builder.adapter Faraday.default_adapter
      end
    end
  end
end
