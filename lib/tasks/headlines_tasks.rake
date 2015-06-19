namespace :headlines do
  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    Headlines::Domain.order("rank").find_each do |domain|
      results = Headlines::AnalyzeDomainHeaders.call(url: domain.name).scan_results

      domain.scans.create!(results: results) if results
    end
  end

  desc "Parse Alexa 1m domains and update rank of domains"
  task update_domain_ranks: :environment do
    Headlines::TopMillionDomain.new(file: Headlines::DomainsArchive.new).fetch_in_batches(limit: 10_000) do |rows|
      Headlines::ImportDomains.call(rows: rows)
    end
  end

  desc "Seed some test data for industries and their domains"
  task seed_industries: :environment do
    create_industries
    categories = Headlines::Category.where(industry_id: Headlines::Industry.pluck(:id))

    categories_have_domains?(categories) || create_domains_categories(categories.to_ary)
  end

  def create_domains_categories(categories)
    Headlines::Domain
      .order("rank")
      .find_in_batches(batch_size: 100) do |domains|
      category = categories.shift

      domains.each { |domain| domain.categories << category }
    end
  end

  def categories_have_domains?(categories)
    Headlines::DomainsCategory.where(category_id: categories.pluck(:id)).any?
  end

  def create_industries
    Headlines::Industry.any? || Headlines::Domain.transaction do
      industries = %w(Economy Internel Games Beauty Others).map do |name|
        Headlines::Industry.create!(name: name)
      end

      industries.map do |industry|
        Headlines::Category.create!(title: industry.name, industry_id: industry.id)
      end
    end
  end
end
