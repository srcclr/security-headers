module Headlines
  class ParseSecurityHeaders
    include Interactor

    def call
      context.fail! unless response.success?

      context.headers = parse_headers
    rescue Faraday::ClientError
      context.fail!(message: I18n.t("connection.failed", url: context.url))
    end

    private

    def response
      @response ||= connection.get do |req|
        req.url "/"
        req.options.timeout = 15
        req.options.open_timeout = 10
      end
    end

    def parse_headers
      security_headers.map { |(header, value)| header_class(header).new(header, value) }
    end

    def security_headers
      formatted_headers.slice(*SECURITY_HEADERS)
    end

    def formatted_headers
      return response.headers unless response.headers["public-key-pins-report-only"]

      response.headers.merge("public-key-pins" => "#{response.headers['public-key-pins-report-only']};report-only")
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
