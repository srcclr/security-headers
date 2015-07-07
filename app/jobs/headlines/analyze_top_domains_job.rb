module Headlines
  class AnalyzeTopDomainsJob < ActiveJob::Base
    queue_as :default

    def perform
      Domain.find_each do |domain|
        result = AnalyzeDomainHeaders.call(url: domain.name)
        if result.success?
          domain.scans.create(headers: result.params,
                              results: result.scan_results,
                              score: result.score)
        end
      end
    end
  end
end
