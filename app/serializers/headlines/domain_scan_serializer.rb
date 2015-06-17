module Headlines
  class DomainScanSerializer < ActiveModel::Serializer
    attributes :name, :country

    has_one :scan

    private

    def country
      IsoCountryCodes.find(object.country_code).name || object.country_code
    end

    def scan
      object.scans.last
    end
  end
end
