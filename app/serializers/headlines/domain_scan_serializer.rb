module Headlines
  class DomainScanSerializer < DomainSerializer
    has_one :category, serializer: CategoryWithParentSerializer

    private

    def category
      options[:category]
    end

    def domains
      options[:domains] || []
    end
  end
end
