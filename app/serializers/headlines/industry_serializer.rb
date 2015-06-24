module Headlines
  class IndustrySerializer < BaseIndustrySerializer
    has_many :industry_ranked_domains, serializer: DomainSerializer
  end
end
