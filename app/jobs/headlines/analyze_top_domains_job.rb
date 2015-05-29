module Headlines
  class AnalyzeTopDomainsJob < ActiveJob::Base
    queue_as :default

    def perform
      Domain.find_each do |domain|
        result = ParseSecurityHeaders.call(url: domain.name)
        if result.success?
          domain.update(tests: result.tests)
        end
      end
    end
  end
end
