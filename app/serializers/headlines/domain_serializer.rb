module Headlines
  class DomainSerializer < ActiveModel::Serializer
    has_one :scan
    attributes :name, :rank
  end
end
