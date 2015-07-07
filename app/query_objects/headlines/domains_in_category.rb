module Headlines
  class DomainsInCategory
    attr_reader :category, :filter_options
    private :category, :filter_options

    def initialize(category, filter_options = {})
      @category = category
      @filter_options = filter_options
    end

    delegate :count, :limit, :includes, :join, :order, to: :all

    def all
      @domains = domains.where(country_code: country_code) if filter_options[:country]

      domains
    end

    private

    def domains
      @domains ||= Domain.joins(:categories)
                   .select("DISTINCT ON (headlines_domains.name) headlines_domains.*")
                   .order("headlines_domains.name")
                   .where(["? = ANY(headlines_categories.parents)", category.id])
    end

    def country_code
      IsoCountryCodes.search_by_name(filter_options[:country])[0].alpha2 if filter_options[:country]
    end
  end
end
