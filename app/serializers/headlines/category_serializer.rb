module Headlines
  class IndustrySerializer < BaseIndustrySerializer
    has_many :domains, serializer: DomainSerializer

    private

    def domains
      options[:domains] || object.domains
    end
  end
end
