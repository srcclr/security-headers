module Headlines
  class DomainSerializer < ActiveModel::Serializer
    attributes :id, :name, :rank, :country, :scan_results, :score

    private

    def country
      if object.country_code.present?
        IsoCountryCodes.find(object.country_code).name
      else
        object.country_code
      end
    end
  end
end
