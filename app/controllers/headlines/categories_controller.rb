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
      categories.map do |category|
        category_as_json(
          category,
          limit: domains_per_category,
          serializer: CategoryWithDomainsSerializer
        )
      end
    end

    def category
      @category ||= CategoryWithParents.new(
        Headlines::Category.includes(:parent, :categories).find(params[:id])
      )
    end

    def category_as_json(category, options = {})
      serializer = options.delete(:serializer) || CategorySerializer

      serialize_data(
        category,
        serializer,
        root: false,
        domains: category_domains(category, options)
      )
    end

    def filtered_domains(domains)
      filtered_domains_by_name(
        FilteredDomains.new(domains: domains, filter_options: filter_options).all
      )
    end

    def filtered_domains_by_name(domains)
      DomainsWithName.new(domains: domains, filter_options: filter_options).all
    end

    def category_domains(category, limit: 25)
      filtered_domains(
        DomainsInCategory.new(category: category)
          .includes(:scans)
          .joins(:scans)
          .where("headlines_scans.id = (SELECT MAX(headlines_scans.id) FROM headlines_scans WHERE headlines_scans.domain_id = headlines_domains.id)")
          .offset(offset)
          .order(:rank)
          .limit(limit)
      )
    end

    def filter_options
      params.slice(:country, :ratings, :headers, :domain_name)
    end

    def offset
      params[:offset] || 0
    end

    def domains_per_category
      params[:domains_per_category] || 100
    end
  end
end
