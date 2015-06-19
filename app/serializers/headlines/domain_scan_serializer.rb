module Headlines
  class DomainScanSerializer < ActiveModel::Serializer
    attributes :name, :country, :industry, :vulnerabilities_report

    has_one :scan

    private

    def scan
      object.scans.last
    end

    def industry
      Industry.first
    end

    def country
      IsoCountryCodes.find(object.country_code).name || object.country_code
    end

    def vulnerabilities_report
      GenerateVulnerabilityReport.call(industry: industry).report
    end
  end
end
