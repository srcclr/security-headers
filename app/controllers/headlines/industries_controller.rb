module Headlines
  class IndustriesController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def index
      respond_to do |format|
        format.json { render(json: industries_as_json) }

        format.html do
          store_preloaded("industries", MultiJson.dump(industries_as_json))
          render "default/empty"
        end
      end
    end

    private

    def industries_as_json
      serialize_data(industries, IndustrySerializer)
    end

    def industries
      Industry.joins(industry_ranked_domains: :scan)
        .includes(industry_ranked_domains: :scan)
        .where(["industry_rank <= ?", domains_per_industry])
    end

    def domains_per_industry
      params[:domains_per_industry] || 100
    end
  end
end
