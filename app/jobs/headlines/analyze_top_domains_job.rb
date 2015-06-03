module Headlines
  class AnalyzeTopDomainsJob < ActiveJob::Base
    queue_as :default

    def perform
      Domain.find_each do |domain|
        result = AnalyzeDomainHeaders.call(url: domain.name)
        Scan.create(headers: result.params,
                    results: result.scan_results,
                    headlines_domain_id: domain.id) if result.success?
      end
    end
  end
end
