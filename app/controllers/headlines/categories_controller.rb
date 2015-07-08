module Headlines
  class CategoriesController < ApplicationController
    skip_before_action :redirect_to_login_if_required, :check_xhr

    respond_to :html, :json

    def index
      respond_to do |format|
        format.json { render(json: categories_as_json) }

        format.html do
          store_preloaded("categories", MultiJson.dump(categories_as_json))
          render "default/empty"
        end
      end
    end

    def show
      respond_to do |format|
        format.json { render(json: category_as_json(category)) }

        format.html do
          store_preloaded("category", MultiJson.dump(category_as_json(category)))
          render "default/empty"
        end
      end
    end

    private

    def categories
      Headlines::Category.where(category_id: 1)
    end

    def categories_as_json
      categories.map { |category| category_as_json(category, limit: domains_per_category) }
    end

    def category
      @category ||= Headlines::Category.includes(:parent, :categories).find(params[:id])
    end

    def category_as_json(category, options = {})
      serialize_data(
        category,
        CategorySerializer,
        root: false,
        domains: category_domains(category, options)
      )
    end

    def category_domains(category, limit: 25)
      DomainsInCategory.new(category: category, filter_options: filter_options)
        .includes(:scans)
        .offset(offset)
        .order("rank DESC")
        .limit(limit)
    end

    def filter_options
      params.slice(:country)
    end

    def offset
      params[:offset] || 0
    end

    def domains_per_category
      params[:domains_per_category] || 100
    end
  end
end
