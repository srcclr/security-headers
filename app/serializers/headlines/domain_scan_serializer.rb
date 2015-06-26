module Headlines
  class DomainScanSerializer < DomainSerializer
    attributes :vulnerabilities_report

    has_one :industry, serializer: BaseIndustrySerializer

    private

    def industry
      options[:industry]
    end

    def vulnerabilities_report
      VulnerabilitiesReport.new(industry.industry_ranked_domains.map(&:scan_results)).report
    end
  end
end
