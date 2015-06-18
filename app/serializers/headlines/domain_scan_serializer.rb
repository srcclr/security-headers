module Headlines
  class DomainScanSerializer < ActiveModel::Serializer
    attributes :name, :country, :vulnerabilities_report

    has_one :scan

    private

    def country
      IsoCountryCodes.find(object.country_code).name || object.country_code
    end

    def scan
      object.scans.last
    end

    def vulnerabilities_report
      GenerateVulnerabilityReport.call().report
    end
  end
end
