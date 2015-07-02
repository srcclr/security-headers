module Headlines
  class IndustrySerializer < BaseCategorySerializer
    has_many :domains, serializer: DomainSerializer

    private

    def domains
      options[:domains] || object.domains
    end
  end
end
