module Headlines
  class CategoriesController < ApplicationController
    skip_before_action :redirect_to_login_if_required, :check_xhr

    respond_to :html, :json

    def index
      respond_to do |format|
        format.json { render(json: root_categories_with_stats) }

        format.html do
          store_preloaded("categories", MultiJson.dump(root_categories_with_stats))
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

    def root_categories_with_stats
      {
        domains_scanned: Headlines::Domain.where.not(last_scan_id: nil).count,
        last_scan: Headlines::Scan.last.try(:created_at),
        categories: categories_as_json
      }
    end

    def categories_as_json
      serialized_categories = categories.map do |category|
        category_as_json(
          category,
          limit: domains_per_category,
          serializer: CategoryWithDomainsSerializer
        )
      end

      serialized_categories.sort! { |a, b| b[:total_domain_count] <=> a[:total_domain_count] }
    end

    def categories
      Headlines::Category.where(category_id: 1)
    end

    def category
      @category ||= CategoryWithParents.new(
        Headlines::Category.includes(:parent, :categories).find(params[:id])
      )
    end

    def category_as_json(category, options = {})
      serializer = options.delete(:serializer) || CategorySerializer
      category_domains = filtered_domains(domains_with_scans(category))

      serialize_data(
        category,
        serializer,
        root: false,
        total_domain_count: category_domains.count(:id),
        domains: category_domains.limit(options[:limit] || 25)
      )
    end

    def domains_with_scans(category)
      DomainsInCategory.new(category: category)
        .includes(:last_scan)
        .joins(:last_scan)
        .offset(offset)
        .order(:rank)
    end

    def filtered_domains(domains)
      filtered_domains_by_name(
        FilteredDomains.new(domains: domains, filter_options: filter_options).all
      )
    end

    def filtered_domains_by_name(domains)
      DomainsWithName.new(domains: domains, filter_options: filter_options).all
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
