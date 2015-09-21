module Headlines
  class DomainScanSerializer < DomainSerializer
    attributes :http_headers, :csp_header

    has_one :category, serializer: CategoryWithParentSerializer

    private

    def http_headers
      sorted_headers(object.last_scan_headers[0..-2])
    end

    def csp_header
      object.last_scan_headers.last
    end

    def category
      options[:category]
    end

    private

    def sorted_headers(headers)
      headers.sort { |h1, h2| SECURITY_HEADERS.index(h1["name"]) <=> SECURITY_HEADERS.index(h2["name"]) }
    end
  end
end
