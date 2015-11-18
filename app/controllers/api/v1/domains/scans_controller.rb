module Api
  module V1
    module Domains
      class ScansController < Api::V1::BaseController
        def create
          render json: scan_as_json, root: false
        end

        private

        def scan_as_json
          scan_result.success? ? headers : {}
        end

        def scan_result
          @scan_result ||= Headlines::AnalyzeDomainHeaders.call(url: params[:url])
        end

        def headers
          headers = scan_result[:params].slice(:http_headers, :csp_header)
          headers = headers[:http_headers] << headers[:csp_header].slice(:name, :value, :score)

          headers = headers.map do |header|
            [header[:name], { value: header[:value], score: header[:score] }]
          end

          Hash[headers]
        end
      end
    end
  end
end
