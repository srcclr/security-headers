module Headlines
  class CategorySerializer < BaseCategorySerializer
    has_many :domains, serializer: DomainSerializer

    with_options serializer: BaseCategorySerializer do |category|
      category.has_many :categories
      category.has_many :parents
      category.has_one :parent
    end

    private

    def domains
      options[:domains] || object.domains
    end
  end
end
