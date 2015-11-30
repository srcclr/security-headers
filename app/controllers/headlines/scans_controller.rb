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

    def domain_as_json
      { name: url, ssl_enabled: result.ssl_enabled }.merge(scan_results)
    end

    def url
      domain_params[:url].gsub(%r{.?https?://}i, "")
    end

    def scan_results
      return { error: result.message } unless result.success?

      result[:params].slice(:score, :http_score, :csp_score, :http_headers, :csp_header)
    end

    def result
      @result ||= AnalyzeDomainHeaders.call(url: url)
    end

    def domain_params
      params.permit(:url)
    end
  end
end
