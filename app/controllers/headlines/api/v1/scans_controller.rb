module Headlines
  module Api
    module V1
      class ScansController < BaseController
        def create
          if scan_result.success?
            render json: JSON.pretty_generate(headers), root: false
          else
            head :unprocessable_entity
          end
        end

        private

        def scan_result
          @scan_result ||= Headlines::AnalyzeDomainHeaders.call(url: params[:url])
        end

        def headers
          headers = scan_result[:params][:headers]

          headers = headers.map do |header|
            [header[:name], { value: header[:value], rating: header[:rating] }]
          end

          Hash[headers]
        end
      end
    end
  end
end
