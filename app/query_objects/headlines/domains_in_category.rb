module Headlines
  class DomainsInCategory
    attr_reader :category
    private :category

    def initialize(category: nil)
      @category = category
    end

    delegate :count, :limit, :includes, :join, :order, to: :all

    def all
      Domain.where("headlines_domains.parent_category_ids && ARRAY[?]", category.id)
    end
  end
end
