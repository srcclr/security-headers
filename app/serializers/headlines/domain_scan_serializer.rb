module Headlines
  class DomainScanSerializer < DomainSerializer
    attributes :http_headers, :csp_header

    has_one :category, serializer: CategoryWithParentSerializer

    private

    def http_headers
      object.scan_headers[0..-2]
    end

    def csp_header
      object.scan_headers.last
    end

    def category
      options[:category]
    end

    def domains
      options[:domains] || []
    end
  end
end
