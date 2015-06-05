module Headlines
  class GenerateScanResultsHash
    include Interactor

    def call
      context.scan_results = scan_results
    end

    private

    def scan_results
      Hash[context.headers.map { |header| [header.name, header.score] }]
    end
  end
end
