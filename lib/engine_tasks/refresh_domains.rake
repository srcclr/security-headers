namespace :headlines do
  desc "Parse Alexa 1m domains and update rank of domains"
  task refresh_domains: :environment do
    progressbar = ProgressBar.create(total: total_count, format: "%a %e %P% Processed: %c from %C")
    Headlines::TopMillionDomain.new(file: Headlines::DomainsArchive.new).fetch_in_batches(limit: total_count) do |rows|
      Headlines::ImportDomains.call(rows: rows, progressbar: progressbar)
    end
  end

  def total_count
    SiteSetting.scan_domain_count || 10_000
  end
end
