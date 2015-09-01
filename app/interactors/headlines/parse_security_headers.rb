module Headlines
  class ParseSecurityHeaders
    include Interactor

    def call
      context.fail! unless response.success?

      context.headers = parse_headers.push(parse_csp)
    end

    private

    def response
      @response ||= connection.get("/")
    rescue Faraday::ClientError, Errno::ETIMEDOUT
      @response = head_request
    end

    def head_request
      @head_request = connection.head("/")
    rescue Faraday::ClientError, Errno::ETIMEDOUT
      context.fail!(message: I18n.t("connection.failed", url: context.url))
    end

    def parse_csp
      Headlines::SecurityHeaders::ContentSecurityPolicy.new(response.headers, response.body, context.url)
    end

    def parse_headers
      security_headers.map { |(header, value)| header_class(header).new(header, value) }
    end

    def security_headers
      empty_headers_hash.merge(formatted_headers.slice(*SECURITY_HEADERS))
    end

    def empty_headers_hash
      Hash[SECURITY_HEADERS.zip(Array.new(SECURITY_HEADERS.size, ""))]
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
