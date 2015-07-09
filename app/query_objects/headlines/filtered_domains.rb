module Headlines
  class FilteredDomains
    attr_reader :filter_options
    private :filter_options

    def initialize(domains:, filter_options:)
      @domains = domains
      @filter_options = filter_options
    end

    delegate :map, to: :all

    def all
      @domains = country_filtered_domains(@domains, country: filter_options[:country])
      if filter_options[:score_range]
        @domains = filter_options[:exclusion_range] ? domains_out_of_score(@domains) : domains_in_score(@domains)
      end

      @domains
    end

    private

    def country_filtered_domains(domains, country:)
      return domains unless country

      domains.where(country_code: country_code)
    end

    def domains_out_of_score(domains)
      domains.joins(:scans).where.not(headlines_scans: { score: numbered_score_range })
    end

    def domains_in_score(domains)
      domains.joins(:scans).where(headlines_scans: { score: numbered_score_range })
    end

    def numbered_score_range
      Range.new(*filter_options[:score_range].map(&:to_i))
    end

    def country_code
      IsoCountryCodes.search_by_name(filter_options[:country])[0].alpha2 if filter_options[:country]
    end
  end
end
