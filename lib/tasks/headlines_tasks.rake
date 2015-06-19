namespace :headlines do
  desc "Seed some test data for industries and their domains"
  task update_domain_ranks: :environment do
    Headlines::TopMillion.new(file: Headlines::DomainsArchive.new).fetch_in_batches do |rows|
      Headlines::ImportDomains.call(rows: rows)
    end
  end

  desc "Seed some test data for industries and their domains"
  task seed_industries: :environment do
    create_industries
    categories = Headlines::Category.where(industry_id: Headlines::Industry.pluck(:id))

    categories_have_domains?(categories) || categories.each do |category|
      Headlines::Domain.order("rank").find_in_batches(batch_size: 100) do |domains|
        domains.each { |domain| domain.categories << category }
      end
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
