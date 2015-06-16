module Headlines
  class DomainScanSerializer < ActiveModel::Serializer
    attributes :name, :country_code

    has_one :scan

    def scan
      object.scans.last
    end
  end
end
