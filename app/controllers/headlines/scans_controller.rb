module Headlines
  class ScansController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def show
      respond_to do |format|
        format.html do
          store_preloaded("domain_scan", MultiJson.dump(domain_as_json))
          render "default/empty"
        end
        format.json { render(json: domain_as_json) }
      end
    end

    private

    def url
      domain_params[:url].gsub(%r{^https?://}, "")
    end

    def domain_as_json
      {
        name: url,
        scan_results: scan_results
      }
    end

    def scan_results
      AnalyzeDomainHeaders.call(url: url).scan_results
    end

    def domain_params
      params.permit(:url)
    end
  end
end
