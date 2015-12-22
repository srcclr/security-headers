module Headlines
  class ParseSecurityHeaders
    include Interactor

    def call
      unless response.success?
        context.status = response.status
        context.fail!(message: I18n.t("errors.general"))
      end

      context.ssl_enabled = response.env.url.scheme == "https"
      context.headers = parse_headers.push(parse_csp)
    end

    private

    def response
      @response ||= connection.get
    rescue Faraday::ClientError, URI::InvalidURIError, Errno::ETIMEDOUT, Faraday::SSLError
      @response = head_request
    end

    def head_request
      @head_request = connection.head
    rescue Faraday::ClientError, URI::InvalidURIError, Errno::ETIMEDOUT, Faraday::SSLError => exception
      context.errors = exception.inspect
      error_i18n = exception.class.to_s.gsub("::", ".").downcase
      context.fail!(message: I18n.t("errors.#{error_i18n}", default: I18n.t("errors.general")))
    end

    def parse_csp
      Headlines::SecurityHeaders::ContentSecurityPolicy.new(sanitized_headers, response.body, context.url)
    end

    def parse_headers
      security_headers.map { |(header, value)| header_class(header).new(header, value) }
    end

    def security_headers
      empty_headers_hash.merge(formatted_headers.slice(*headers_to_analyze))
    end

    def empty_headers_hash
      Hash[headers_to_analyze.zip(Array.new(headers_to_analyze.size, ""))]
    end

    def formatted_headers
      return sanitized_headers unless sanitized_headers["public-key-pins-report-only"]

      sanitized_headers.merge("public-key-pins" => "#{sanitized_headers['public-key-pins-report-only']};report-only")
    end

    def sanitized_headers
      @sanitized_headers ||= Hash[
        response.headers.map { |k, v| [k, v.force_encoding("iso8859-1").encode("utf-8")] }
      ]
    end

    def headers_to_analyze
      SECURITY_HEADERS + OTHER_HEADERS
    end

    def header_class(header)
      "Headlines::SecurityHeaders::#{header.titleize.gsub(' ', '')}".constantize
    end

    def connection
      Faraday.new(url: "http://#{context.url}", headers: request_headers) do |builder|
        builder.request :url_encoded
        builder.use FaradayMiddleware::FollowRedirects, limit: 10
        builder.adapter Faraday.default_adapter
      end
    end

    def request_headers
      {
        accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        accept_encoding: "none",
        accept_language: "en-US,en;q=0.5",
        user_agent: "Mozilla/5.0 AppleWebKit/537.36 Chrome/46.0.2490.71 Safari/537.36 Firefox/41.0"
      }
    end
  end
end
