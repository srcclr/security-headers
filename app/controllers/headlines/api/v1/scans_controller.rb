module Headlines
  module Api
    module V1
      class ScansController < BaseController
        def create
          if scan_result.success?
            render json: headers, root: false
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
            [header[:name], { value: header[:value], rating: rating(header[:score], header[:name]) }]
          end

          Hash[headers]
        end

        def rating(score, header_name)
          if header_name == "content-security-policy"
            Headlines::Ratings::CspHeaderCalculator.new(score).call
          else
            Headlines::Ratings::HttpHeaderCalculator.new(score).call
          end
        end
      end
    end
  end
end
