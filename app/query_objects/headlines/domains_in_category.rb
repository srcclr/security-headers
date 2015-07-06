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
        .select("DISTINCT ON (headlines_domains.name) headlines_domains.*")
        .order("headlines_domains.name")
        .where(["? = ANY(headlines_categories.parents)", category.id])
    end
  end
end
