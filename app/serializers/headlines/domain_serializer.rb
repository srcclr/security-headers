module Headlines
  class DomainSerializer < ActiveModel::Serializer
    attributes :id, :name, :rank, :country, :scan_results, :score, :last_scan_date

    private

    def country
      if object.country_code.present?
        IsoCountryCodes.find(object.country_code).name
      else
        object.country_code
      end
    end

    def last_scan_date
      object.scan.created_at
    end
  end
end