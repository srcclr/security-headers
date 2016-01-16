module Headlines
  class CategoryWithDomainsSerializer < BaseCategorySerializer
    attributes :total_domain_count

    has_many :domains, serializer: DomainSerializer

    private

    def total_domain_count
      options[:total_domain_count]
    end

    def domains
      options[:domains] || object.domains
    end
  end
end
