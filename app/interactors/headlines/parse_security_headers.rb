module Headlines
  class ParseSecurityHeaders
    include Interactor

    SECURITY_HEADERS = %w(strict-transport-security
                          x-xss-protection
                          x-content-type-options
                          x-frame-options
                          content-security-policy)

    def call
      response = connection.get("/")
      if response.success?
        context.headers = Hash[parse_headers(response.headers)]
        context.tests = tests(context.headers)
      else
        context.fail!(message: "We can't parse #{context.url} headers. Server respond with status: #{response.status}.")
      end
    rescue Faraday::ConnectionFailed => e
      context.fail!(message: "Couldn't connect to site: #{context.url}.")
    end

    private

    def parse_headers(headers)
      headers.slice(*SECURITY_HEADERS).map do |(header, value)|
        [header, header_class(header).new(value).params]
      end
    end

    def tests(headers)
      results = Hash[SECURITY_HEADERS.zip(Array.new(SECURITY_HEADERS.size, 'fail'))]
      headers.each do |(header, params)|
        results[header] = params[:enabled] ? 'pass' : 'fail'
      end
      results
    end

    def header_class(header)
      "Headlines::SecurityHeaders::#{header.titleize.gsub(' ', '')}".constantize
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
