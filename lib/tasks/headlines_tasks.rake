namespace :headlines do
  desc "Seed some test data for industries and their domains"
  task seed_industries: :environment do
    Headlines::Domain.transaction do
      industries = %w(Economy Internel Games Beauty Others).map do |name|
        Headlines::Industry.create!(name: name)
      end

      categories = industries.map do |industry|
        Headlines::Category.create!(title: industry.name, industry_id: industry.id)
      end

      ranks = [1..100, 101..200, 201..300, 301...400, 401..500]

      categories.each_with_index do |category, index|
        ranks[index].each do |rank|
          domain = Headlines::Domain.create!(name: "domain#{rank}.com", rank: rank)
          domain.categories << category

          Headlines::Scan.create(domain_id: domain.id, results: scan_results)
        end
      end
    end
  end

  def scan_results
    Hash[Headlines::SECURITY_HEADERS.map { |header| [header, rand(1..100)] }]
  end
end
