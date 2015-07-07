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
      @domains = @domains.where(country_code: country_code) if filter_options[:country]

      if filter_options[:score_greater_than] || filter_options[:score_less_than]
        @domains = @domains.joins(:scans).where("headlines_scans.score >= ? OR headlines_scans.score <= ?",
                                                filter_options[:score_greater_than] || 101,
                                                filter_options[:score_less_than] || -1)
      end

      @domains
    end

    private

    def country_code
      IsoCountryCodes.search_by_name(filter_options[:country])[0].alpha2 if filter_options[:country]
    end
  end
end
