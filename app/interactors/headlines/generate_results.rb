module Headlines
  class GenerateResults
    include Interactor

    HTTP_RATINGS = [(-100..-5), (-4..0), (1..5), (6..100)]
    CSP_RATINGS = [(-100..-6), (-5..-2), (-1..2), (3..100)]

    def call
      context.params = { headers: headers,
                         http_headers: headers[0..-2],
                         csp_header: headers.last,
                         results: scan_results,
                         score: overall_score,
                         http_score: http_score,
                         csp_score: csp_score }
    end

    private

    def headers
      @headers ||= context.headers.map(&:params)
    end

    def scan_results
      @scan_results ||= Hash[context.headers.map { |header| [header.name, header.score] }]
    end

    def http_score
      score = scan_results.slice(*SECURITY_HEADERS).values.sum
      HTTP_RATINGS.index { |r| r.include?(score) }
    end

    def csp_score
      score = scan_results["content-security-policy"] || CSP_RULES[:no_csp_header]
      CSP_RATINGS.index { |r| r.include?(score) }
    end

    def overall_score
      [http_score, csp_score].max
    end
  end
end
