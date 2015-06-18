module Headlines
  class IndustrySerializer < ActiveModel::Serializer
    attributes :name
    has_many :industry_ranked_domains, each_serializer: DomainSerializer
  end
end
