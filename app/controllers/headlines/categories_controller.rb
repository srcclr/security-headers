module Headlines
  class CategoriesController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    TOP_CATEGORIES = ["Search Engines", "Economy"]

    respond_to :html, :json

    def index
      respond_to do |format|
        format.json { render(json: categories) }
        format.html { render "default/empty" }
      end
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
