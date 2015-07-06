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

    def show
      respond_to do |format|
        format.json { render(json: industry_as_json) }

        format.html do
          store_preloaded("industry", MultiJson.dump(industry_as_json))
          render "default/empty"
        end
      end
    end

    private

    def industry
      @industry ||= Industry.find(params[:id])
    end

    def filtered_industry_domains
      @industry_domains = industry_domains.where(country_code: country_code) if country_code

      industry_domains
    end

    def industry_domains
      @industry_domains ||= industry.industry_ranked_domains.includes(:scan).offset(offset).limit(25)
    end

    def country_code
      IsoCountryCodes.search_by_name(params[:country])[0].alpha2 if params[:country]
    end

    def offset
      params[:offset] || 0
    end

    def industry_as_json
      serialize_data(industry, IndustrySerializer, root: false, industry_ranked_domains: filtered_industry_domains)
    end

    def industries_as_json
      serialize_data(filtered_industries, IndustrySerializer)
    end

    def filtered_industries
      if params[:country]
        @industries = industries.where("headlines_industry_ranked_domains.country_code = ?", country_code)
      end

      industries
    end

    def industries
      @industries ||= Industry.joins(industry_ranked_domains: :scan)
                              .includes(industry_ranked_domains: :scan)
                              .where(["industry_rank <= ?", domains_per_industry])
    end

    def domains_per_industry
      params[:domains_per_industry] || 100
    end
  end
end
