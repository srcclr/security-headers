module Headlines
  class CategoryWithParents < SimpleDelegator
    def parents
      return Category.none if model.parents.blank?

      Category.where(id: model.parents)
    end

    private

    alias_method :model, :__getobj__
  end
end
