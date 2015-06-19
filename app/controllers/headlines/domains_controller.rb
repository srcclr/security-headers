module Headlines
  class DomainsController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def show
      serialized = serialize_data(domain, DomainScanSerializer, root: false)

      respond_to do |format|
        format.html do
          store_preloaded("domain_scan", MultiJson.dump(serialized))
          render "default/empty"
        end
        format.json { render(json: serialized) }
      end
    end

    private

    def domain
      Domain
        .joins(:industries)
        .includes(:industries, :scans)
        .where("headlines_industries.id = ?", params[:industry_id])
        .where(id: params[:id])
        .first
    end
  end
end
