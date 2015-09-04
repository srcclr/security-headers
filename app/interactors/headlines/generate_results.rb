module Headlines
  class GenerateResults
    include Interactor

    HTTP_RATINGS = [(-100..-1), (0..4), (5..9), (10..100)]
    CSP_RATINGS = [(-100..-6), (-5..-1), (0..4), (5..100)]

    def call
      context.params = context.headers.map(&:params)
      context.scan_results = scan_results
      context.http_score = HTTP_RATINGS.index { |r| r.include?(http_score) }
      context.csp_score = CSP_RATINGS.index { |r| r.include?(csp_score) }
      context.score = overall_score
    end

    private

    def scan_results
      Hash[context.headers.map { |header| [header.name, header.score] }]
    end

    def http_score
      context.scan_results.slice(*SECURITY_HEADERS).values.sum
    end

    def csp_score
      context.scan_results["content-security-policy"] || CSP_RULES[:no_csp_header]
    end

    def overall_score
      [context.http_score, context.csp_score].max
    end
  end
end
