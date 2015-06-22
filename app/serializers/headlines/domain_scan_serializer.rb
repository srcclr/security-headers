module Headlines
  class DomainScanSerializer < ActiveModel::Serializer
    attributes :id, :name, :country, :scan_results, :vulnerabilities_report

    has_one :industry, serializer: BaseIndustrySerializer

    private

    def industry
      options[:industry]
    end

    def country
      if object.country_code.present?
        IsoCountryCodes.find(object.country_code).name
      else
        object.country_code
      end
    end

    def vulnerabilities_report
      VulnerabilitiesReport.new(industry.industry_ranked_domains.map(&:scan).map(&:results)).report
    end
  end
end
