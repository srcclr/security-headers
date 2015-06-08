module Headlines
  class CategoriesController < ApplicationController
    TOP_CATEGORIES = ["Search Engines", "Economy"]

    respond_to :json

    def index
      respond_with(categories)
    end

    private

    def categories
      Category.joins(:domains_ranked)
        .includes(:domains_ranked)
        .where(["rank_by_category > ?", domains_per_category])
        .where(title: TOP_CATEGORIES)
    end

    def domains_per_category
      params[:domains_per_category] || 100
    end
  end
end
