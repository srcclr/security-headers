namespace :headlines do
  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    Headlines::Domain.order("rank").find_each do |domain|
      results = Headlines::AnalyzeDomainHeaders.call(url: domain.name).scan_results
      domain.scans.create!(results: results) if results
    end
  end
end
