module Headlines
  class IndustriesController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def index
      respond_to do |format|
        format.json { render(json: industries) }
        format.html { render "default/empty" }
      end
    end

    private

    def industries
      Industry.joins(:industry_ranked_domains)
        .includes(:industry_ranked_domains)
        .where(["industry_rank <= ?", domains_per_industry])
    end

    def domains_per_industry
      params[:domains_per_industry] || 100
    end
  end
end
