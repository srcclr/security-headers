module Headlines
  class DomainSerializer < ActiveModel::Serializer
    attributes :name, :rank
  end
end
