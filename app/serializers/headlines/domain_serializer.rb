module Headlines
  class DomainSerializer < ActiveModel::Serializer
    attributes :name, :rank, :scan_results
  end
end
