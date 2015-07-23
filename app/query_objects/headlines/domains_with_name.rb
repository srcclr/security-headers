module Headlines
  class DomainsWithName
    attr_reader :domains, :name
    private :domains, :name

    def initialize(domains: Domain.none, filter_options: {})
      @domains = domains
      @name = filter_options[:domain_name]
    end

    def all
      name ? find_domains : domains
    end

    private

    def find_domains
      domains.where("headlines_domains.name ILIKE ?", "#{name}%")
    end
  end
end
