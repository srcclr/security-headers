module Headlines
  class DomainsInCategory
    attr_reader :category
    private :category

    def initialize(category:)
      @category = category
    end

    delegate :count, :limit, :includes, :join, :order, to: :all

    def all
      Domain.joins(:categories)
        .where(["? = ANY(headlines_categories.parents)", category.id])
    end
  end
end
