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
      headers.sort { |h1, h2| all_headers.index(h1["name"]) <=> all_headers.index(h2["name"]) }
    end

    def all_headers
      SECURITY_HEADERS + OTHER_HEADERS
    end
  end
end
