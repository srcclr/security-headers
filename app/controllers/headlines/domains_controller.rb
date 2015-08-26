module Headlines
  class DomainsController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def show
      respond_to do |format|
        format.html do
          store_preloaded("domain", MultiJson.dump(domain_as_json))
          render "default/empty"
        end

        format.json { render(json: domain_as_json) }
      end
    end

    private

    def domain_as_json
      serialize_data(
        domain,
        DomainScanSerializer,
        root: false,
        category: category,
        domains: category_domains(category)
      )
    end

    def category
      @category ||= CategoryWithParents.new(Category.find(params[:category_id]))
    end

    def category_domains(category)
      DomainsInCategory.new(category: category)
        .includes(:scan)
        .joins(:scan)
        .order("rank DESC")
        .limit(100)
    end

    def domain
      DomainsInCategory.new(category: category)
        .includes(:scan)
        .order("rank DESC")
        .find(params[:id])
    end
  end
end
