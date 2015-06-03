module Headlines
  class GenerateScanResultsHash
    include Interactor

    def call
      context.scan_results = scan_results(context.headers)
    end

    private

    def scan_results(headers)
      Hash[headers.map { |header| [header.name, header.score] }]
    end
  end
end
