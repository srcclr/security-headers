module Headlines
  class GenerateScanResultsHash
    include Interactor

    def call
      context.scan_results = SECURITY_HEADERS_EMPTY_SCORES.merge(scan_results)
      context.score = score(context.scan_results.values)
    end

    private

    def score(values)
      values.sum.to_f / values.size
    end

    def scan_results
      Hash[context.headers.map { |header| [header.name, header.score] }]
    end
  end
end
