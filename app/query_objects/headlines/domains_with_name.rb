module Headlines
  class DomainsWithName
    attr_reader :domains, :name
    private :domains, :name

    def initialize(domains:, params:)
      @domains = domains
      @name = params[:domain_name]
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
