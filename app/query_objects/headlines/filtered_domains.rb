module Headlines
  class FilteredDomains
    attr_reader :filter_options
    private :filter_options

    def initialize(domains: Domain.none, filter_options: {})
      @domains = domains
      @filter_options = filter_options
    end

    delegate :map, to: :all

    def all
      @domains = country_filtered_domains(@domains, country: filter_options[:country])
      @domains = headers_filtered_domains(@domains, headers: filter_options[:headers])
      @domains = rating_filtered_domains(@domains, ratings: filter_options[:ratings])

      @domains
    end

    private

    def country_filtered_domains(domains, country: nil)
      return domains unless country

      domains.where(country_code: country_code)
    end

    def headers_filtered_domains(domains, headers: nil)
      return domains unless headers

      headers_join = headers.each_with_index.map do |header, i|
        %(
          INNER JOIN json_array_elements(headlines_scans.headers) AS header_#{i}
          ON header_#{i}->>'name' = '#{header}' AND header_#{i}->>'value' != ''
        )
      end.join(" ")

      domains.joins(headers_join)
    end

    def rating_filtered_domains(domains, ratings: nil)
      return domains unless ratings

      domains.where(headlines_scans: { score: ratings })
    end

    def country_code
      IsoCountryCodes.search_by_name(filter_options[:country])[0].alpha2 if filter_options[:country]
    end
  end
end
