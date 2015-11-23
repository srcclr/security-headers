namespace :headlines do
  desc "Parse Alexa 1m domains and update rank of domains"
  task refresh_domains: :environment do
    Headlines::TopMillionDomain.new(file: Headlines::DomainsArchive.new).fetch_in_batches(limit: 20_000) do |rows|
      Headlines::ImportDomains.call(rows: rows)
    end
  end
end
