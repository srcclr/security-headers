module Headlines
  class ScansController < ApplicationController
    skip_before_action :redirect_to_login_if_required

    respond_to :html, :json

    def show
      respond_to do |format|
        format.html do
          store_preloaded("url_scan", MultiJson.dump(domain_as_json))
          render "default/empty"
        end
        format.json { render(json: domain_as_json) }
      end
    end

    private

    def url
      query_params[:url].start_with?("http") ? query_params[:url].gsub(/^https?:\/\//, '') : query_params[:url]
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

    def query_params
      params.permit(:url)
    end
  end
end
