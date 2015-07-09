module Headlines
  class CategoryWithParentSerializer < BaseCategorySerializer
    has_many :parents, serializer: BaseCategorySerializer
  end
end
