module Headlines
  class CategorySerializer < BaseCategorySerializer
    has_many :domains, serializer: DomainSerializer
    has_many :categories, serializer: BaseCategorySerializer
    has_one :parent, serializer: BaseCategorySerializer

    private

    def domains
      options[:domains] || object.domains
    end
  end
end
