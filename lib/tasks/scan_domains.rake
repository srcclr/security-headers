namespace :headlines do
  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    Headlines::Domain.order("rank").find_each do |domain|
      result = Headlines::AnalyzeDomainHeaders.call(url: domain.name)

      if result.success?
        domain.scans.create!(headers: result.params,
                             results: result.scan_results,
                             score: result.score)
      end
    end
  end
end
