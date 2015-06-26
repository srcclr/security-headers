module Headlines
  class IndustrySerializer < BaseIndustrySerializer
    has_many :industry_ranked_domains, serializer: DomainSerializer

    private

    def industry_ranked_domains
      options[:industry_ranked_domains] || object.industry_ranked_domains
    end
  end
end
