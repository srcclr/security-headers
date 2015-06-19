module Headlines
  class DomainScanSerializer < ActiveModel::Serializer
    attributes :name, :country, :scan_results, :vulnerabilities_report

    has_one :industry, serializer: BaseIndustrySerializer

    private

    def industry
      options[:industry]
    end

    def country
      IsoCountryCodes.find(object.country_code).name || object.country_code
    end

    def vulnerabilities_report
      GenerateVulnerabilityReport.call(industry: industry).report
    end
  end
end
