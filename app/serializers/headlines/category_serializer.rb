module Headlines
  class CategorySerializer < ActiveModel::Serializer
    attributes :title
    has_many :domains
  end
end
