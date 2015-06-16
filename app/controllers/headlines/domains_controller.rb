module Headlines
  class DomainsController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def show
      respond_to do |format|
        format.json { render(json: domain, serializer: DomainScanSerializer, root: false) }
        format.html { render "default/empty" }
      end
    end

    private

    def domain
      Domain.includes(:scans).find(params[:id])
    end
  end
end
