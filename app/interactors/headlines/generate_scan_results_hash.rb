module Headlines
  class GenerateScanResultsHash
    include Interactor

    def call
      context.scan_results = SECURITY_HEADERS_EMPTY_SCORES.merge(scan_results)
      context.score = context.scan_results.values.sum
    end

    private

    def scan_results
      Hash[context.headers.map { |header| [header.name, header.score] }]
    end
  end
end
