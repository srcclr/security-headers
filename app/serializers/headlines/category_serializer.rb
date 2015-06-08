module Headlines
  class CategorySerializer < ActiveModel::Serializer
    attributes :title
    has_many :domains_ranked, each_serializer: DomainSerializer
  end
end
