module Headlines
  class IndustrySerializer < ActiveModel::Serializer
    attributes :name
    has_many :industry_ranked_domains, serializer: DomainSerializer
  end
end
