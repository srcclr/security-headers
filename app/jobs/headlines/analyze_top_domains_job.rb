module Headlines
  class AnalyzeTopDomainsJob < ActiveJob::Base
    queue_as :default

    def perform
      Domain.find_each do |domain|
        result = AnalyzeDomainHeaders.call(url: domain.name)
        domain.scans.create(headers: result.params, results: result.scan_results) if result.success?
      end
    end
  end
end
