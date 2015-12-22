namespace :headlines do
  DEFAULT_DOMAINS_COUNT = 10_000

  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    Headlines::ScanDomains::Runner.new(total_count, progressbar).call
  end

  def total_count
    # SiteSetting.scan_domain_count || DEFAULT_DOMAINS_COUNT
    1_000
  end

  def progressbar
    ProgressBar.create(total: total_count, format: "%a %e %P% Processed: %c from %C")
  end
end
