module Headlines
  class DomainScanSerializer < DomainSerializer
    attributes :vulnerabilities_report

    has_one :category, serializer: BaseIndustrySerializer

    private

    def category
      options[:category]
    end

    def domains
      options[:domains] || []
    end

    def vulnerabilities_report
      VulnerabilitiesReport.new(domains.map(&:scan_results)).report
    end
  end
end
